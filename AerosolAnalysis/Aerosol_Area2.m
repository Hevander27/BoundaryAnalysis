function [AREA, LENGTH, WIDTH] = Aerosol_Area2(input_map, route, display)

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

visited_terminal = [];
visited_initial = [];

for m = 1:length(route)
    curr_cell = route(m);
    %%%%%%%%%%%%%%%%%%%%%%%VISUALIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp('display',display)
        map(curr_cell) = 7;
        image(1.50, 1.50, map);
        grid on; axis image;
        drawnow;
    end

    %%%%%%%%%%%%%%extracting the vector and find the last%%%%%%%%%%%%%%
    [curr_row ,curr_col] = ind2sub([nrows, ncols], curr_cell);
    init_vector = logic_map(1:curr_row,curr_col);

    trim_vector = init_vector(find(init_vector,1,'first'):end);
    if isempty(trim_vector), continue; end

    area_vector = trim_vector(find(~trim_vector,1,'first'):end-1);
    last_zero = find(area_vector==0,1,'last'); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%AREA_BOUNDS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    terminator_cell = curr_cell - (length(area_vector)-(last_zero-1));
    if isempty(terminator_cell), continue; end
    if any(visited_ends(:) == terminator_cell), continue; end
    
    
    init_cell = curr_cell - 1;
    


    if any(ismember(trim_vector,route)) &&... 
       any(ismember(terminator_cell, route))
        for a = init_cell:-1: terminator_cell + 1
        
            map(a) = 5;
            image(1.50, 1.50, map);
            grid on; axis image;
            %drawnow;
        end
    else
        continue;
    end

    visited_inital = [visited_initial(:) ,  curr_cell]
 


end