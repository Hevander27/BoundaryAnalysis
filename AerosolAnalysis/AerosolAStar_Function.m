function [PATH,TABLE, STEP] = AerosolAStar_Function(input_map,start_coords, goal_coords, drawMapEveryTime, uniformGrid)
% Dijkstra's algorithm on a grid - Inputs and OutPuts
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

%  setting up a color map to visualize expansion
%  1) setting up colormap
%  1 - white - free cell
%  2 - black - obstacle
%  3 - red - explored frontiers
%  4 - blue - future frontiers
%  5 - green - start
%  6 - yellow - goal
cmap = [1 1 1;... % white
        0 0 0;... % black
        1 0 0;... % red
        0 0 1;... % blue
        0 1 0;... % green
        1 1 0;... % yellow
        0.5 0.5 0.5]; % grey

colormap(cmap)

[nrows, ncols] = size(input_map);

% map - table that keeps track of the start of each grid cell
map = zeros(nrows, ncols);

map(~input_map) = 1; % Mark free cells with white
map(input_map)  = 2; % Mark obstacles cells with black

% Generate linear indices of start and gaol nodes
% sub2ind = (col_index-1) * col size + row_index = (9-1)*10+8 = 88
start_node = sub2ind(size(map), start_coords(1), start_coords(2));
goal_node = sub2ind(size(map), goal_coords(1), goal_coords(2));

map(start_node) =  5;   % mark start node with green
map(goal_node) = 6;     % mark goal node with yellow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Cost array
COST = ones(size(input_map));
% skip this part if cost is uniform
if (~uniformGrid)
    if start_coords(1) > goal_coords(1)
        COST(start_coords(1)+1, start_coords(2)) = 1000;
    elseif start_coords(1) < goal_coords(1)
        COST(start_coords(1)-1, start_coords(2)) = 1000; 
    end

    if start_coords(2) > goal_coords(2)
        COST(start_coords(1), start_coords(2)+1) = 1000;
    elseif start_coords(2) < goal_coords(2)
        COST(start_coords(1), start_coords(2)-1) = 1000;
    end

    COST(goal_coords(1), goal_coords(2)) = 1;

end
% skip this part if cost is uniform
if (~uniformGrid)
    COST(input_map) = Inf;
    % setting cells zlose to obstacles with high cost of 10
    High_Cost = 100;
    for node = 1 : numel(input_map)
        % check for obstacle cells
        % if true then it is an obstacle so set its neighbor at High_Cost
        if (input_map(node))
            [row, col] = ind2sub(size(map), node);
            for n = 1: 4
                if n == 1
                    neighbor_row = row -1 ; neighbor_col = col;
                elseif n == 2
                    neighbor_row = row +1 ; neighbor_col = col;
                elseif n == 3
                    neighbor_row = row; neighbor_col = col - 1;
                else
                    neighbor_row = row; neighbor_col = col + 1;
                end

                % check that neighbor is inside the map
                if (neighbor_row < 1 || neighbor_row > size(input_map,1))
                    continue
                elseif (neighbor_col < 1 || size(input_map,2))
                    continue
                end

                neighborID = sub2ind(size(map), neighbor_row, neighbor_col);
        
                % skip if barrior or goal_node OR start_node
                if (input_map(neighborID) ==1)
                    continue;
                end

                if (neighborID == start_node)
                    continue
                end

                if (neighborID == goal_node)
                    contiune
                end

                COST(neighborID) = High_Cost;

            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this section creates a customed cost in the map. Obstacles neighbor nodes
% take cost of 100. One of the Start node neighbor cell will be assigned a 
% cost of 1000 based on the location of the start node relative to goal
% node

% Cost array
H_FUNC = zeros(size(input_map));
% skip this part if cost is uniform
for node = 1 : numel(input_map) 
    [node_coords(1), node_coords(2)] = ind2sub(size(H_FUNC), node);
    H_FUNC(node) = abs(goal_coords(1)-node_coords(1)) + abs(goal_coords(2)-node_coords(2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize distance arrau as Inf in each cell
F_NODE = Inf(nrows, ncols);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate F(start_node)
% Cost of start node is just its H_Func value
F_NODE(start_node) = H_FUNC(start_node) + COST(start_node); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for each grid cell this array hold the index ofits paarent
PARENT = zeros(nrows, ncols);

%distanceFromStart(start_node) = 0;

% Keep track of number of node expanded
STEP = 0;
Frontier_Explored = 1;
TABLE = Inf(nrows*ncols*2,5);
TABLE(1,1) = start_node;
TABLE(1,2) = STEP;
TABLE(1,3) = 0;
TABLE(1,4) = Inf;
TABLE(1,5) = COST(start_node);

% MAIN LOOP
while true
    map(start_node) = 5;
    map(goal_node) = 6;

    % make drawMapEveryTime = true if you wanto see how the 
    % nodes are expanded on the grid
    if (drawMapEveryTime)
        %pause(0.1);
        image(1.5, 1.5, map);
        grid on; axis image;
        drawnow;
    end
    % Find the node with the minimum distance
    % min is the value of min distance
    % current index of the first min value (in case there are more than one min)
    [min_F, curr_FrontierID] = min(F_NODE(:));
    % is inf True for infinite elements, isinf(X) returns an array that
    % contains 1's where elements of X are +Inf or -Inf and 0's where they
    % are not; Example isinf([pi NaN Inf -Inf]) is [0 0 1 1]

    if ((curr_FrontierID == goal_node) || isinf(min_F))
        break
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    map(curr_FrontierID) = 3; % mark current node as visited (red means visited)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we need a way so that the current frontier will not be picked from the 
% array to explire in the future. Since we get new frontier that has
% minimum distance to start mode so one way to mark the current frontier
% not to be picked again is by marking its location with Infj
    F_NODE(curr_FrontierID) = Inf; % remove this node from furhter consideration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute row, column coordinates of current node
    [i, j] = ind2sub(size(F_NODE), curr_FrontierID);
    % *********************************************************************
    % MY CODE HERE
    % Visit each neighbor of the current node and update the map, distance
    % and the parent tables approprately
    for n = 1 : 4
        % 1 visit each enighbor of the Frontier_node node
        if n == 1 % Up
            row = i - 1; col = j;
        elseif n == 2 % Right
            row = i ; col = j + 1;
        elseif n == 3 % Left
            row = i ; col = j - 1;
        else % Down
            row = i + 1 ; col = j;
        end

        neighborID = sub2ind(size(map), row, col);
        if row < 1 || row > size(map,1) ||...
           col < 1 || col > size(map,2) ||...
           (map(neighborID) > 1 && map(neighborID) ~= 6)||...
            input_map(neighborID)

            continue
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        STEP = STEP + 1;
        % add ID to array 
        TABLE(STEP + 1, 1) = neighborID; 
        % add its distance from start
        TABLE(STEP + 1, 2) = TABLE(Frontier_Explored, 2) + 1;
        % add its exploration step
        TABLE(STEP + 1, 3) = STEP;
        % add info regarding route, should be parent
        TABLE(STEP + 1, 4) = curr_FrontierID;
        %FrontierID_Col = TABLE(:, 1);
        TABLE(STEP + 1, 5) = F_NODE(neighborID);
        
        F_NODE(neighborID) = COST(curr_FrontierID) + COST(neighborID) + H_FUNC(neighborID);
        PARENT(neighborID) = curr_FrontierID;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % update the map color
        if (map(neighborID) ~= 6) % goal should be always yellow
             map(neighborID) = 4; % mark neighbor with blue (to be visited)    
        end

        if (TABLE(Frontier_Explored, 1) >= 100)% ~=100
            break%~~~~~~~~~MIGHT REMOVE
        end

        % nodes are expanded on the grid
        if (drawMapEveryTime)
            image(1.50, 1.50, map);
            grid on; axis image;
            drawnow;
        end
    end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     after exploring current frontier go to another
     Frontier_Explored = Frontier_Explored + 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
TABLE = TABLE(~isinf(TABLE(:,1)),:);
FrontierID_Col = TABLE(:, 1);

%% Construct rout from start to goal by following the parent links
route = Inf(1, (nrows*ncols),'single');
if (TABLE(Frontier_Explored, 1) == Inf)
    route = [];
else
    Frontier_Prnt = TABLE(:,4);
    FrontierID_idx = length(FrontierID_Col);        % step entry is 1 less than table rows, so add 1
    route(end) = FrontierID_Col(FrontierID_idx);    % adding the goal_node neighborID
    count = length(route) - 1;                      % decrementing counter so star_node is first

    while  Frontier_Prnt(FrontierID_idx)~=Inf
     
        route(count) = Frontier_Prnt(FrontierID_idx);
        count = count - 1;
        FrontierID_idx = find(FrontierID_Col == Frontier_Prnt(FrontierID_idx));
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    PATH = route(route ~= Inf);

    for k = 1:length(PATH) -1
        map(PATH(k)) = 7;
        image(1.5,1.5 , map);
        grid on; axis image;
        drawnow;
    end

TABLE = array2table(TABLE,'VariableNames', ...
                    {'Neighbor', ...
                    'Distance', ...
                    'Steps', ...
                    'Parent', ...
                    'Cost'});
end
