function [circlespace,meshX,meshY] = make_circlespace(r)

global window screenRect white black grey xc yc meshX meshY circlespace correct incorrect wrong_key  stim_pixels visual_angle_in_degrees dist_to_screen_cm

% Obtain screen size and pixel info 
[screen_size_mm(1), screen_size_mm(2)] = Screen('DisplaySize', 0);
screen_width_cm = screen_size_mm(1)/10;
screen_height_cm = screen_size_mm(2)/10;
[screen_width_pixels,screen_height_pixels] = Screen('WindowSize', 0);
screen_pixel_density = screen_width_pixels/screen_width_cm;
stim_width = 2*dist_to_screen_cm*tan((visual_angle_in_degrees/2)*(pi/180));
stim_pixels = stim_width*screen_pixel_density;
stim_radius = ceil(stim_pixels/2);
    
% create an appropriate circlespace matrix
h = 2*stim_radius+1;
circlespace = zeros(h,h);
center_point = stim_radius+1;
for i = 1:h
   for j = 1:h
        if (((i-center_point)^2 + (j-center_point)^2) <= stim_radius^2)
             circlespace(i,j) = 1;
        end
   end
end
[meshX,meshY] = meshgrid(1:h,1:h);