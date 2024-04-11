function [ROUTE, STEP, OUTMAP] = AerosolDFS_Function(input_map, start_coords, goal_coords, drawMapEveryTime,display)
% Run DFS algorithm on grid
% Inputs :
%   input_map : a logical array where the freespace cells are false or 0
%   and the obstacles are true or 1
%   start_coords and goal_coords : Coordinates of the start and end call
%   repsectively, the first entry is the row and the second the column.
% Outputs :  
%   route : An array containing the linear indices of the cells along the
%   shortest route from start to goal or an empty array if there is no
%   route. This is a single dimensional vector
%   Step: Remembr to also return  the total number of nodes expanded during
%   your search.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will convert to Dstar for most efficient path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE_VISUALIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1) setting up colormap
%  1 - white - free cell
%  2 - black - obstacle
%  3 - red - explored frontiers
%  4 - blue - future frontiers
%  5 - green - start
%  6 - cyan - end
%  7 - yellow - route
cmap = [1 1 1;... % white
        0 0 0;... % black
        1 0 0;... % red
        0 0 1;... % blue
        0 1 0;... % green   
        0 1 1;... % cyan    
        1 1 0]; % % yellow
colormap(cmap)

[nrows, ncols] = size(input_map);   
map = zeros(nrows, ncols);               
map_size = [nrows, ncols];              % save size output for speed
OUTMAP = zeros(nrows,ncols);

start_node = sub2ind(size(map), start_coords(1), start_coords(2));
goal_node  = sub2ind(size(map), goal_coords(1),  goal_coords(2));
      

map(~input_map) = 1;                     % Sets aerosol outline to white
map(input_map)  = 2;                     % Sets non-outline cells to black
map(start_node) = 5;                     % Sets start_node to green
map(goal_node)  = 6;                     % Sets end_node to cyan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initilaize postition and route logging data structures for visited cells

Visited_Frontier = zeros(1,nrows*ncols); % 2D-array logging visited cells
Visited_Frontier(1) = start_node;        % Put start_node in visted array
stack = CStack(start_node);              % Initialize stack with start_node                            
STEP = 0;                                % # of iternations until goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%V_MAIN_LOOP_V%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while true

    map(start_node) = 5;
    map(goal_node)  = 6;

    Frontier_node = stack.top();         % The current node (top of stack)      
    if (Frontier_node == goal_node)      % Break if frontier node is goal
        break;
    end
    
    map(Frontier_node) = 3;              % Mark frontier with red on map
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % return row, column coordinates for the Frontier_node 
    [i , j] = ind2sub(map_size, Frontier_node); 
    % set a pointer to the next element to be added whicis Step + 1
    % Visist each neighbor of the Frontier_node and update the map
    % If n neighbor is valid for exploration wit either visit before or exit
    for n = 1 : 4
        if n == 1    % RIGHT
            row = i ; col = j + 1;
        elseif n == 2    % LEFT
            row = i ; col = j - 1;
        elseif n == 3    % UP
            row = i - 1; col = j;
        else % DOWN
            row = i + 1 ; col = j;
        end
        
        neighborID = sub2ind(map_size, row, col);   
        if (row < 1 || row > nrows || ...
            col < 1 || col > ncols || ...
            input_map(neighborID)  || ...
            any(Visited_Frontier == neighborID)) 
            if n < 4
                continue
            else  
                stack.pop();
                break
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % All tests are passed so this neighbor is a good neighbor
        % Update add it to ht earray and update its related info
        STEP = STEP + 1;                 % increment exploration step
        stack.push(neighborID);          % add ID to array 
        OUTMAP(neighborID) = 255;        % construct outline

        % add its distance from start
        Visited_Frontier = [Visited_Frontier(:,:) neighborID];
        if (map(neighborID) ~= 6)   % goal should be always yellow
             map(neighborID) = 4;   % mark neighbor with blue (to be visited)    
        end

        if ((nargin == 5) && drawMapEveryTime)
            image(1.50, 1.50, map);
            grid on; axis image;
            drawnow;
        end

        break;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (stack.isempty())
        break;
    end
end

if (stack.isempty())
    ROUTE = [];
else
    Explored_Nodes = cell2mat(stack.content());
    ROUTE = Explored_Nodes;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%OPTIONAL_DISPLAY%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 5 
    if strcmp('display',display)
        for k = 2:length(ROUTE) - 1
            map(ROUTE(k)) = 7;
            image(1.5,1.5 , map);
            grid on; axis image;
            drawnow;
        end
    elseif ~strcmp('display',display)
        error('Error: Incorrect argument, please type "display".');
    end
end


end