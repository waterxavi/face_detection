function Coords = MyFaceDetectionFunction(A)
% Santiago Galella Toledo NIA:173710
% Jordi Pla NIA: 182613
% Agustin Rovira NIA: 175768

% Face Detection System using Viola-Jones Algorithm.
% A: Image in which faces are going to be detected.
% Coords: Vector containing the coordinates [x1 y1 x2 y2] of the face/s.

% First Detector Model
Detect1 = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[100 100],'MergeThreshold',3,'ScaleFactor' , 1.2);
BoundB = step(Detect1,A);

% Second Detector Model 
if isempty(BoundB)
Detect2 = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[99 99],'MergeThreshold',5,'ScaleFactor' , 1.15);
BoundB = step(Detect2,A);
end

% Third Detector Model 
if isempty(BoundB)
Detect3 = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[98 98],'MergeThreshold',7,'ScaleFactor' , 1.1);
BoundB = step(Detect3,A);
end

% Fourth Detector Model 
if isempty(BoundB)
Detect4 = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[97 97],'MergeThreshold',9,'ScaleFactor' , 1.05);
BoundB = step(Detect4,A);
end

% Fifth Detector Model 
if isempty(BoundB)
Detect5 = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[96 96],'MergeThreshold',11,'ScaleFactor' , 1.001);
BoundB = step(Detect5,A);
end
     
% Check if the Bounding Box is a face
BoundB = inspection(BoundB,A);
          

% Coordinates are computed both if there are faces or not
if ~isempty(BoundB)
    Coords=[BoundB(1), BoundB(2), BoundB(1) + BoundB(3), BoundB(2) + BoundB(4)];
else
    Coords=double.empty(0,4);
end
 
% We are interested only in the two biggest faces.
    n_faces = size(BoundB, 1);
    if n_faces > 2 % If there are more than 2 faces
        face_area = zeros(1, n_faces);
        for i = 1:n_faces % Iterate over the faces and get the area of the bounding box
            face_area(i) = (BoundB(i, 3) - BoundB(i, 1)) * (BoundB(i, 4) - BoundB(i, 2));
        end
        [~, ind] = sort(face_area); % Get the bigger areas 
        BoundB = BoundB(ind(1:2), :); % Return only the 2 biggest faces
    end
    
end

function BoundB = inspection(BoundB,A) % Is there a real face? ...

        if ~isempty(BoundB) 

            DetectR=vision.CascadeObjectDetector('RightEyeCART','MinSize',[20 20],'MergeThreshold',4,'UseROI',true);
            DetectL=vision.CascadeObjectDetector('Nose','MinSize',[20 20],'MergeThreshold',7,'UseROI',true);
                        
            if (size(BoundB,1)>1)
                
                for i=1:size(BoundB,1)
                     BoundBR=step(DetectR,A,BoundB(i,:));
                     BoundBL=step(DetectL,A,BoundB(i,:));
                     if  ~isempty(BoundBL)||~isempty(BoundBR) 
                         BoundBi(i,:)=BoundB(i,:);
                     else
                         BoundBi(i,:)=[0 0 0 0];
                     end 
                end

                BoundB=BoundBi;
                BoundB(~any(BoundB,2),:)=[];

            else

                BoundBR=step(DetectR,A,BoundB);
                BoundBL=step(DetectL,A,BoundB);
                 if  ~isempty(BoundBL)||~isempty(BoundBR)
                     %BoundB=BoundB;
                 else
                     BoundB=double.empty(0,4);  
                 end 
            end
        end
end      