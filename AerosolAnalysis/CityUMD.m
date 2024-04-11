classdef CityUMD < handle


    properties
    
    end

    methods

        function [ROUTE, STEP, OUTMAP] = AerosolDFS_Function(input_map, start_coords, goal_coords, drawMapEveryTime,display)
        cmap = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 1 0]; % % yellow
        colormap(cmap)
        [nrows, ncols] = size(input_map);  map = zeros(nrows, ncols);               
        map_size = [nrows, ncols];         OUTMAP = zeros(nrows,ncols);  
        start_node = sub2ind(size(map), start_coords(1), start_coords(2));
        goal_node  = sub2ind(size(map), goal_coords(1),  goal_coords(2));
        map(~input_map) = 1;   map(start_node) = 5;                
        map(input_map)  = 2;   map(goal_node)  = 6;                 
        Visited_Frontier = zeros(1,nrows*ncols); % 2D-array logging visited cells
        Visited_Frontier(1) = start_node;        % Put start_node in visted array
        stack = CStack(start_node);              % Initialize stack with start_node                            
        STEP = 0;                                % # of iternations until goal
        while true
            map(start_node) = 5;
            map(goal_node)  = 6;
            Frontier_node = stack.top();         % The current node (top of stack)      
            if (Frontier_node == goal_node)      % Break if frontier node is goal
                break;
            end
            map(Frontier_node) = 3;              % Mark frontier with red on map
            [i , j] = ind2sub(map_size, Frontier_node); 
            for n = 1 : 4
                switch n
                    case 1    
                        row = i ; col = j + 1;
                    case 2    
                        row = i ; col = j - 1;
                    case 3    
                        row = i - 1; col = j;
                    otherwise 
                        row = i + 1 ; col = j;
                end
                neighborID = sub2ind(map_size, row, col);
                if (row < 1 || row > nrows || ...
                    col < 1 || col > ncols || ...
                    input_map(neighborID) || ...
                    any(Visited_Frontier == neighborID)) 
                    if n < 4
                        continue
                    else  
                        stack.pop();
                        break
                    end
                end
                STEP = STEP + 1;                 % increment exploration step
                stack.push(neighborID);          % add ID to array 
                OUTMAP(neighborID) = 255;        % construct outline
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


        function [TABLE,PATH, STEP] = BFS_SearchAlgo_Function(input_map, start_coords, goal_coords, drawMapEveryTime,display)
        cmap = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0; 1 1 0; 0.5 0.5 0.5]; 
        colormap(cmap)
        [nrows, ncols] = size(input_map); map = zeros(nrows, ncols);
        map(~input_map) = 1; % Mark free cells with white
        map(input_map)  = 2; % Mark obstacles cells with black
        start_node = sub2ind(size(map), start_coords(1), start_coords(2));
        goal_node  = sub2ind(size(map), goal_coords(1),  goal_coords(2));
        distFromStart = 0; STEP = 0;
        Frontier_Dist_Step = Inf(nrows*ncols, 4);
        Frontier_Dist_Step(1,1) = start_node;
        Frontier_Dist_Step(1,2) = distFromStart;
        Frontier_Dist_Step(1,3) = STEP;
        Frontier_Dist_Step(1,4) = Inf;
        Frontier_Ptr = 1;
        bool = true;
        while bool == true
            map(start_node) = 5;
            map(goal_node) = 6;
            Frontier_node = Frontier_Dist_Step(Frontier_Ptr, 1);
            map(Frontier_node) = 3;
            [i , j] = ind2sub(size(map), Frontier_node);
            for n = 1 : 4
                if n == 1 
                    row = i - 1; col = j;
                elseif n == 2 
                    row = i ; col = j + 1;
                elseif n == 3
                    row = i ; col = j - 1;
                else 
                    row = i + 1 ; col = j;
                end
                neighborID = sub2ind(size(map), row, col);
                if (row < 1 || row > nrows || ...
                    col < 1 || col > ncols || ...
                    any(Frontier_Dist_Step(:, 1) == neighborID)|| ...
                    input_map(neighborID))
                    continue
                end 
                STEP = STEP + 1;
                Frontier_Dist_Step(STEP + 1, 1) = neighborID ;
                Frontier_Dist_Step(STEP + 1, 2) = Frontier_Dist_Step(Frontier_Ptr, 2) + 1;
                Frontier_Dist_Step(STEP + 1, 3) = STEP;
                Frontier_Dist_Step(STEP + 1, 4) = Frontier_node;
                FrontierID_Col = Frontier_Dist_Step(:, 1);
                if (map(neighborID) ~= 6) % goal should be always yellow
                     map(neighborID) = 4; % mark neighbor with blue (to be visited)    
                end
                if (neighborID == goal_node)
                    Frontier_Dist_Step(STEP + 1, 4) = Frontier_node;
                    bool = false;
                    break;
                end
                if ((nargin == 5) && drawMapEveryTime)
                    image(1.50, 1.50, map);
                    grid on; axis image;
                    drawnow;
                end
            end
            Frontier_Ptr = Frontier_Ptr + 1;
            if (Frontier_Dist_Step(Frontier_Ptr, 1) == Inf)
                break
            end
        end
        table_length = length(Frontier_Dist_Step(Frontier_Dist_Step(:,1) ~= Inf));
        TABLE = Frontier_Dist_Step(1:table_length, :);
        route = Inf(1, (nrows*ncols),'single');
        if (Frontier_Dist_Step(Frontier_Ptr, 1) == Inf)
            route = [];
        else
            Frontier_Prnt = Frontier_Dist_Step(:,4);
            FrontierID_idx = STEP+1;
            route(end) = FrontierID_Col(FrontierID_idx);
            count = length(route) - 1;
            while  Frontier_Prnt(FrontierID_idx)~=Inf
                route(count) = Frontier_Prnt(FrontierID_idx);
                count = count - 1;
                FrontierID_idx = find(FrontierID_Col == Frontier_Prnt(FrontierID_idx));
            end
            PATH = route(route ~= Inf);
            if nargin == 5 
                if strcmp('display',display)
                     for k = 1:length(PATH) -1
                        map(start_node) = 5;
                        map(goal_node) = 6;
                        map(PATH(k)) = 7;
                        image(1.5,1.5 , map);
                        grid on; axis image;
                        drawnow;
                    end
                elseif ~strcmp('display',display)
                    error('Error: Incorrect argument, please type "display".');
                end
            end
        end
        TABLE = array2table(TABLE,'VariableNames', {'Neighbor','Distance', 'Steps','Parent'});
        end


        function [PATH, TABLE, STEP] = Dijkstra_SearchAlgo_Function(input_map,start_coords, goal_coords, drawMapEveryTime, uniformGrid)
        cmap = [1 1 1; 0 0 0;1 0 0;0 0 1; 0 1 0; 1 1 0; 0.5 0.5 0.5]; 
        colormap(cmap)
        [nrows, ncols] = size(input_map);
        map = zeros(nrows, ncols);
        map(~input_map) = 1; % Mark free cells with white
        map(input_map)  = 2; % Mark obstacles cells with black
        start_node = sub2ind(size(map), start_coords(1), start_coords(2));
        goal_node = sub2ind(size(map), goal_coords(1), goal_coords(2));
        map(start_node) =  5;   % mark start node with green
        map(goal_node) = 6;     % mark goal node with yellow
        COST = ones(size(input_map));
        if (~uniformGrid)
            if start_coords(1) > goal_coords(1)
                COST(start_coords(1)+1, start_coords(2)) = 1000;
            elseif start_coords(1) < goal_coords(1)
                COST(start_coords(1)-1, start_coords(2)) = 1000; 
            end
            if start_coords(2) > goal_coords(2)
                COST(start_coords(1), start_coords(2)+1)    = 1000;
            elseif start_coords(2) < goal_coords(2)
                COST(start_coords(1), start_coords(2)-1)    = 1000;
            end
            COST(goal_coords(1), goal_coords(2)) = 1;   
        end
        if (~uniformGrid)
            COST(input_map) = Inf;
            High_Cost = 100;
            for node = 1 : numel(input_map)
                if (input_map(node))
                    [row, col] = ind2sub(size(map), node);
                    for n = 1: 4
                        if row ~= 1 && n == 1
                            neighbor_row = row -1 ; neighbor_col = col;
                        elseif n == 2
                            neighbor_row = row; neighbor_col = col + 1;
                        elseif col ~= 1 && n == 3
                            neighbor_row = row; neighbor_col = col - 1;
                        else
                            neighbor_row = row + 1; neighbor_col = col;
                        end
                        if (neighbor_row < 1 || neighbor_row > size(input_map,1))
                            continue
                        elseif (neighbor_col < 1 || neighbor_col >size(input_map,2))
                            continue
                        end
                        neighborID = sub2ind(size(map), neighbor_row, neighbor_col);
                        if (input_map(neighborID) == 1)
                            continue;
                        end
                        if (neighborID == start_node)
                            continue
                        end
                        if (neighborID == goal_node)
                            continue
                        end
                        COST(neighborID) = High_Cost;
                    end
                end
            end
        end
        distFromStart = Inf(nrows, ncols); %~~~~~NO
        parent = zeros(nrows, ncols);
        distFromStart(start_node) = 0; 
        STEP = 0;
        Frontier_Explored = 1;
        TABLE = Inf(nrows*ncols,5);
        TABLE(1,1) = start_node;
        TABLE(1,2) = 0;
        TABLE(1,3) = STEP;
        TABLE(1,4) = Inf;
        TABLE(1,5) = COST(start_node);
        while true
            map(start_node) = 5;
            map(goal_node) = 6;
            if (drawMapEveryTime)
                image(1.5, 1.5, map);
                grid on; axis image;
                drawnow;
            end
            [min_dist, curr_FrontierID] = min(distFromStart(:));
            if ((curr_FrontierID == goal_node) || isinf(min_dist))
                break
            end
            map(curr_FrontierID) = 3;    % mark current node as visited (red means visited)
            distFromStart(curr_FrontierID) = Inf; % remove this node from furhter consideration
            [i, j] = ind2sub(size(distFromStart), curr_FrontierID);
            for n = 1 : 4
               if n == 1 
                    row = i - 1; col = j;
               elseif n == 2 
                    row = i ; col = j + 1;
               elseif n == 3 
                    row = i ; col = j - 1;
               else
                    row = i + 1 ; col = j;
               end
                neighborID = sub2ind(size(map), row, col);
                if (row < 1 || row > nrows || ...
                   col < 1 || col > ncols  ||...
                   map(neighborID) > 1 && map(neighborID) ~= 6 || ...
                   input_map(neighborID))
                    continue 
                end
                STEP = STEP + 1;
                TABLE(STEP + 1, 1) = neighborID; 
                TABLE(STEP + 1, 2) = TABLE(Frontier_Explored, 2) + 1;
                TABLE(STEP + 1, 3) = STEP;
                TABLE(STEP + 1, 4) = curr_FrontierID;
                TABLE(STEP + 1, 5) = COST(neighborID);
                distFromStart(neighborID) = min_dist + COST(neighborID); 
                parent(neighborID) = curr_FrontierID;
                if (map(neighborID) ~= 6) % goal should be always yellow
                     map(neighborID) = 4; % mark neighbor with blue (to be visited)    
                end
                if (TABLE(Frontier_Explored, 1) >= 100)% ~=100
                    break%~~~~~~~~~MIGHT REMOVE
                end
                if (drawMapEveryTime)
                    image(1.50, 1.50, map);
                    grid on; axis image;
                    drawnow;
                end
            end
            Frontier_Explored = Frontier_Explored + 1;
        end
        len = size(TABLE,1)
        TABLE = TABLE(~isinf(TABLE(:,1)),:);
        FrontierID_Col = TABLE(:, 1)
        route = Inf(1, (nrows*ncols),'single');
        check = Frontier_Explored
        if (TABLE(Frontier_Explored, 1) == Inf)
            route = [];
        else
            Frontier_Prnt = TABLE(:,4);
            FrontierID_idx = length(FrontierID_Col);
            route(end) = FrontierID_Col(FrontierID_idx);
            count = length(route) - 1;
        
            while  Frontier_Prnt(FrontierID_idx)~=Inf
             
                route(count) = Frontier_Prnt(FrontierID_idx);
                count = count - 1;
                FrontierID_idx = find(FrontierID_Col == Frontier_Prnt(FrontierID_idx));
            end
            PATH = route(route ~= Inf);
        
            for k = 1:length(PATH) -1
                map(start_node) = 5;
                map(goal_node) = 6;
                map(PATH(k)) = 7;
        
                image(1.5,1.5 , map);
                grid on; axis image;
                drawnow;
            end
        end
        TABLE = array2table(TABLE,'VariableNames', {'Neighbor','Distance','Steps','Parent','Cost'});
        end

        function [PATH,TABLE, STEP] = AStar_SearchAlgo_Function(input_map,start_coords, goal_coords, drawMapEveryTime, uniformGrid)
        cmap = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0; 1 1 0; 0.5 0.5 0.5]; 
        colormap(cmap)
        [nrows, ncols] = size(input_map);
        map = zeros(nrows, ncols);
        map(~input_map) = 1; % Mark free cells with white
        map(input_map)  = 2; % Mark obstacles cells with black
        start_node = sub2ind(size(map), start_coords(1), start_coords(2));
        goal_node = sub2ind(size(map), goal_coords(1), goal_coords(2));
        map(start_node) =  5;   % mark start node with green
        map(goal_node) = 6;     % mark goal node with yellow
        COST = ones(size(input_map));
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
        if (~uniformGrid)
            COST(input_map) = Inf;
            High_Cost = 100;
            for node = 1 : numel(input_map)
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
                        if (neighbor_row < 1 || neighbor_row > size(input_map,1))
                            continue
                        elseif (neighbor_col < 1 || size(input_map,2))
                            continue
                        end
                        neighborID = sub2ind(size(map), neighbor_row, neighbor_col);
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
        H_FUNC = zeros(size(input_map));
        for node = 1 : numel(input_map) 
            [node_coords(1), node_coords(2)] = ind2sub(size(H_FUNC), node);
            H_FUNC(node) = abs(goal_coords(1)-node_coords(1)) + abs(goal_coords(2)-node_coords(2));
        end
        F_NODE = Inf(nrows, ncols);
        F_NODE(start_node) = H_FUNC(start_node) + COST(start_node); 
        PARENT = zeros(nrows, ncols);
        STEP = 0;
        Frontier_Explored = 1;
        TABLE = Inf(nrows*ncols*2,5);
        TABLE(1,1) = start_node;
        TABLE(1,2) = STEP;
        TABLE(1,3) = 0;
        TABLE(1,4) = Inf;
        TABLE(1,5) = COST(start_node);
        while true
            map(start_node) = 5;
            map(goal_node) = 6;
            if (drawMapEveryTime)
                image(1.5, 1.5, map);
                grid on; axis image;
                drawnow;
            end
            [min_F, curr_FrontierID] = min(F_NODE(:));
            if ((curr_FrontierID == goal_node) || isinf(min_F))
                break
            end
            map(curr_FrontierID) = 3; 
            F_NODE(curr_FrontierID) = Inf; 
            [i, j] = ind2sub(size(F_NODE), curr_FrontierID);
            for n = 1 : 4
                if n == 1 
                    row = i - 1; col = j;
                elseif n == 2 
                    row = i ; col = j + 1;
                elseif n == 3 
                    row = i ; col = j - 1;
                else 
                    row = i + 1 ; col = j;
                end
                if (row < 1 || row > size(map,1)) 
                    continue
                elseif (col < 1 || col > size(map,2))
                    continue
                end
                neighborID = sub2ind(size(map), row, col);
                if (map(neighborID) > 1 && map(neighborID) ~= 6)
                    continue
                end
                if (input_map(neighborID))
                    continue
                end
                STEP = STEP + 1;
                TABLE(STEP + 1, 1) = neighborID; 
                TABLE(STEP + 1, 2) = TABLE(Frontier_Explored, 2) + 1;
                TABLE(STEP + 1, 3) = STEP;
                TABLE(STEP + 1, 4) = curr_FrontierID;
                TABLE(STEP + 1, 5) = F_NODE(neighborID);
                F_NODE(neighborID) = COST(curr_FrontierID) + COST(neighborID) + H_FUNC(neighborID);
                PARENT(neighborID) = curr_FrontierID;
                if (map(neighborID) ~= 6) % goal should be always yellow
                     map(neighborID) = 4; % mark neighbor with blue (to be visited)    
                end
                if (TABLE(Frontier_Explored, 1) >= 100)% ~=100
                    break%~~~~~~~~~MIGHT REMOVE
                end
                if (drawMapEveryTime)
                    image(1.50, 1.50, map);
                    grid on; axis image;
                    drawnow;
                end
            end
             Frontier_Explored = Frontier_Explored + 1;
        end
        len = size(TABLE(:,1));
        TABLE = TABLE(~isinf(TABLE(:,1)),:);
        FrontierID_Col = TABLE(:, 1);
        route = Inf(1, (nrows*ncols),'single');
        if (TABLE(Frontier_Explored, 1) == Inf);
            route = [];
        else
            Frontier_Prnt = TABLE(:,4);
            FrontierID_idx = length(FrontierID_Col);
            route(end) = FrontierID_Col(FrontierID_idx);
            count = length(route) - 1;
            while  Frontier_Prnt(FrontierID_idx)~=Inf
             
                route(count) = Frontier_Prnt(FrontierID_idx);
                count = count - 1;
                FrontierID_idx = find(FrontierID_Col == Frontier_Prnt(FrontierID_idx));
            end
            PATH = route(route ~= Inf);
            for k = 1:length(PATH) -1
                map(start_node) = 5;
                map(goal_node) = 6;
                map(PATH(k)) = 7;
                image(1.5,1.5 , map);
                grid on; axis image;
                drawnow;
            end
        end
        TABLE = array2table(TABLE,'VariableNames',{'Neighbor','Distance','Steps','Parent', 'Cost'});
        end

        
        function [imgArray, pctImg] = imgCluster(img, k, display)
        img =im2double(img);                   % Convert unit8 image to double
        [row, col, xx] = size(img);            % Gets the size of the image
        big = row*col;                         % Shapes image data for fcm use
        data = reshape(img,big,[]);            % reshapes image layers to M*N-by-3
        [~, U] = fcm(data, k, [2 100 1e-5 0]); % returns fuzzy partition matrix
        [ref] = big;                           % Initialize cluster group reference array
        
        for i = 1:(big)
            for p = 1:k
                if(U(p,i) == max(U(:,i)))
                    ref(i) = p;
                end
            end
        end
        ref = reshape(ref,row,[]);           % reshape array to match image size  
        pctImg = zeros(1,k);                  % initialize cluster percent array
        imgArray = zeros(row,col,xx,k);       % initialize 4D array to hold images
            for m = 1:k
                temp = zeros(row,col,3);%    
                for n = 1:row
                    for o = 1:col
                        if(ref(n,o) == m)
                            temp(n,o,:) = img(n,o,:);
                            imgArray(:,:,:,m) = temp;
                            pctImg(m) = nnz(temp)/nnz(img);
                        end
                    end
                end
                if nargin == 3  
                    if strcmp('display',display)
                        figure,imshow(temp, []);
                        txt = sprintf('%.3f', pctImg(m));
                        title(['Cluster Percent: ',txt]);
                    elseif ~strcmp('display',display)
                        error('Error: Incorrect argument, please type "display".');
                    end
                end
            end
        end
       
        function 
        % min_row = min(rows);
        % max_row = max(rows);
        % min_col = min(columns);
        % max_col = max(columns);
        % 
        % jet_length = max_col - min_col;
        % jet_width  = max_row - min_row;
        
        end
    


    end

      
                    
           
            

end
