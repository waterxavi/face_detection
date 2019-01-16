function [boxes] = MyFaceDetectionFunction( img )
    detector = buildDetector();
    % detectFaceParts does not accept greyscale images
    % repmat is a way of "cheating" a greyscale image as a rgb image
    if size(img,3) == 1 
        [bbox bbimg faces bbfaces] = detectFaceParts(detector,repmat( img, [1,1,3] ),2);
    else
        [bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);
    end
    % bbox format: [x0, y0, width, height] (where x0,y0 top left)
    % desired format: [x0, y0, x1, y1] (where x0,y0 top left and x1,y1
    % bottom right)
    boxes = [bbox(1:end,1:2) bbox(1:end,1:2)+bbox(1:end,3:4)];
end