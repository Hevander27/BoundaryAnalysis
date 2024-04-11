% up = col - 1;
% Visted_vertical_Frontier = [];
% vertical_neighbor = sub2ind(map_size, row, up);
% for l = l:length(jet_width) 
%     count = 0;
%     if (vertical_neighbor == 1000)
%         count =  count + 1;
%         while(vertical_neighbor == 1000 || ~any(Visited_Frontier == vertical_neighbor ))
%             count = count + 1;
%             vertical_neighbor = vertical_neighbor-1;
%         end
%     else
%         up = up -1;
%         vertical_neighbor = sub2ind(map_size, row, up);
%     end
% end


up = col - 1;
Visted_vertical_Frontier = [];
vertical_neighbor = sub2ind(map_size, row, up);

% terminator = current column, first index reached in map outline
%  if curr_column contains cells above that are in MAP && has an upper adjancent barrier
%      if curr_column isnt marked with area fillers directly above AND
%      terminator not in Visted_vertical neightbor(or terminator list)
%      AND current_cell not in terminatior list
%       while vertical neighor    
%     else 
         % break out of area finding loop
% end
  
    if (any(init_vector == route) )
        % top bound of vector is highest cell
        init_vector = init_vector(init_vector ~= route);% assumption for only interior blogs
    end

