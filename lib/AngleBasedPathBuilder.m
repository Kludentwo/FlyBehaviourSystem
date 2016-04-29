function [ newvect, ivect ] = AngleBasedPathBuilder( X, Y, anglethreshold, jitterthreshold)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   anglethreshold = 27; % 27 seems to work pretty well.
%   jitterthreshold = 2;

    Pos = [ X; Y ];
    i = 1;
    newvect = [Pos(:,i)];
    ivect(1) = i;
    while ( i < size(X,2) )
        smallangle = true;
        Globalset = false;
        startpos = i;
        while(smallangle == true)
            i = i + 1;
            if (i == size(X,2))
                %% reached end of data;
                break
            end
            if ( Globalset == false )
                res = (Pos(:,i)-(Pos(:,startpos)));
                Globalangle = mod(atan2(res(2),res(1))+2*pi,2*pi)*180/pi;
                if res(1) == 0 && res(2) == 0 %isnan(Globalangle)
                    Globalset = false;
                else
                    Globalset = true;
                end
            end
            newres = (Pos(:,i+1)-(Pos(:,i)));
            Thetares = mod(atan2(newres(2),newres(1))+2*pi,2*pi)*180/pi;
            newangle = abs(Thetares-Globalangle);
            
            if(norm(newres) < jitterthreshold && newangle > anglethreshold)
                newvect = [ newvect Pos(:,i) ];
                ivect = [ivect i];
                % Inside circle of camera noise
                middlepos = Pos(:,i);
                while(norm(Pos(:,i)-middlepos) < jitterthreshold)
                    i = i + 1;
                    if (i == size(X,2))
                        %% reached end of data;
                        smallangle = false;
                        break
                        
                    end
                end                
            else
                if ( newangle > anglethreshold )
                    smallangle = false;
                else
                    res = (Pos(:,i)-(Pos(:,startpos)));
                    Globalangle = mod(atan2(res(2),res(1))+2*pi,2*pi)*180/pi;
                end
            end
        end
        newvect = [ newvect Pos(:,i) ];
        ivect = [ivect i];
    end
end

