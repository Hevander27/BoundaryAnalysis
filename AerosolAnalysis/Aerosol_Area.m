function [AREA, LENGTH, WIDTH] = Aerosol_Area(input_map, route, display)

%%%%%%%%%%%%%%%%%%%%%AREA_CALCULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) extract the column of the current cell, find the vertically
% adjacent cell(index) within input_map that has the minimum distance
% ignoring black cells i.e 0 values
% 2) ignore interior blobs since theyre not in the route 

cmap = [1 1 1;... % white
        0 0 0;... % black
        1 0 0;... % red
        0 0 1;... % blue
        0 1 0;... % green   
        0 1 1;... % cyan
        1 1 0;... % % yellow
        1 0 1]; % magenta
colormap(cmap)

[nrows, ncols] = size(input_map);
map = zeros(nrows, ncols); 
logic_map = logical(~input_map);

map(~logic_map) = 1;                     % Sets aerosol outline to white
map(logic_map)  = 2;                     % Sets non-outline cells to black


min_row = min(nrows);
max_row = max(ncols);
min_col = min(ncols); % start
max_col = max(ncols);

%
LENGTH = max_col - min_col;
WIDTH  = max_row - min_row;
AREA = 0;
%%%%%%%%%%%%%%%%
% find adjacent and diagonal cells for start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

visited_start = [];
visited_ends = [];
for m = 1:length(route)
    curr_cell = route(m);
    visited_ends = [visited_ends(:,:) curr_cell]; 

    if strcmp('display',display)
        
        map(curr_cell) = 7;
        %pause(2);
        image(1.50, 1.50, map);
        grid on; axis image;
        drawnow;
    end
    
        

    [curr_row ,curr_col] = ind2sub([nrows, ncols], curr_cell);
    init_vector = logic_map(1:curr_row,curr_col);

   
        
    trim_vector = init_vector(find(init_vector,1,'first'):end);
    if isempty(trim_vector) 
        continue;
    end

    area_vector = trim_vector(find(~trim_vector,1,'first'):end-1);
    
    last_zero = find(area_vector==0,1,'last'); 
    terminator_cell = curr_cell - (length(area_vector)-(last_zero-1)); 
    % DO VISITED PAIR SYSTEM ANY PAIR WITH A SHARED VALUE IS SKIPPED
    if isempty(terminator_cell) || any(visited_ends(:) == terminator_cell), continue; end 

    
    if ~isempty(terminator_cell) && any(ismember(trim_vector,1)) && input_map(curr_cell -1) == 0 
        if any(visited_ends(:) == terminator_cell)  
                testing = ".....TESTING.....";
                curr_row
                curr_col
                continue
%         elseif any(visited_ends(:) == curr_cell)
%             testing2 = ".....TESTING_MORE.....";           
%             continue
        elseif isempty(trim_vector)
           
            continue
        else
            map(terminator_cell) = 6;
        end
    visited_ends = [visited_ends(:,:) curr_cell]; 
    elseif isempty(terminator_cell) 
        %skipcol = [curr_col, curr_row]
        %skip = "SKIPPING"
       
        continue;

    elseif any(visited_ends(:) == terminator_cell) || any(visited_ends(:) == curr_cell)
       
        continue
    
    elseif any(ismember(terminator_cell, route)) || any(ismember(curr_cell, route))
      
        continue
    else
        map(terminator_cell) = 6;
    end



    init_cell = curr_cell - 1;
    




    %visited_ends = [visited_ends(:,:) curr_cell]; 

    if  all(ismember(trim_vector,[0, 1])) 

%         if any(map(terminator_cell) == 6) ||...
%            any(ismember(visited_ends, terminator_cell)) ||...
%            any(ismember(route, check_vec))
%            check2 = "INSIDE BREAK"
%             continue
%         else
%             check = "CONFIMRED"
%             
%         end
        

        for a = init_cell:-1: terminator_cell + 1

            if any(visited_ends(:) == terminator_cell) 
                testing2 = ".....TESTING_MORE AGAIN....."
               
                continue;
            end
%             if map(a) == 1 || map(a) == 7 
% 
%                 break
%             end


            map(a) = 5;
            %if strcmp('display',display)
            %pause(2);
            image(1.50, 1.50, map);
            grid on; axis image;
            %drawnow;
            %end
        end


    else
        skipping = "SKIPPING HERE"
    
        continue
    end

    
    visited_ends = [visited_ends(:,:) terminator_cell];
   







 end




end

