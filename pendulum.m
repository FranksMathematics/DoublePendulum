function pendulum

    global m1;
    global m2;
    global l1;
    global l2;
    global g;

    m1 = 1;
    m2 = 2;
    l1 = 1;
    l2 = 0.5;
    g = 9.81;

    h = 0.0025;

    % Set initial position
    y = [pi; pi; 0.1;0.01];

    % end time
    max_time = 20;

    % render video
    doVideo = 1;

    if doVideo == 1
        videofile = VideoWriter('pendulum.avi');
        videofile.FrameRate = round(1/h);
        open(videofile);
    end


    % Simple Euler
    for i = 1:round( max_time / h )
        y = y + h*[ y(3); y(4); g1(y); g2(y)  ];

        % plotting
        x0 = 0;
        y0 = 0;

        x1 = l1*sin( y(1) );
        y1 = - l1*cos( y(1) );

        x2 = x1 + l2*sin( y(2) );
        y2 = y1 - l2*cos( y(2) );

        %clf;
        figure(1);
        set(gcf, 'position', [0 0 1000 1000]);
        clf(1);
        hold on
        plot(x0,y0,'o','markerfacecolor','b');
        hold on
        plot(x1,y1,'o','markerfacecolor','b');
        hold on
        plot(x2,y2,'o','markerfacecolor','b');
        hold on
        plot( [x0,x1], [y0,y1] );
        hold on
        plot( [x1,x2], [y1,y2] );
        hold off
        axis([-2 2 -2 2]);
        title(strcat('Time=', num2str(i*h,'%.2f')));

        if doVideo == 1
            frame = getframe(gcf);
            writeVideo(videofile, frame);
        end
    end


    if doVideo == 1
        close(videofile);
    end

end

function res = alpha1(t1, t2)
    global m1;
    global m2;
    global l1;
    global l2;
    global g;

    res = (l2/l1)*( m2/(m1+m2)  )*cos(t1-t2);

end


function res = alpha2(t1, t2)
    global m1;
    global m2;
    global l1;
    global l2;
    global g;

    res = (l1/l2)*cos(t1-t2);
end



function res = f1(t1, t2, w1, w2)
    global m1;
    global m2;
    global l1;
    global l2;
    global g;

    res = (-l2/l1)*(m2/(m1+m2))*w2*w2*sin(t1-t2) - (g/l1)*sin(t1);
end


function res = f2(t1, t2, w1, w2)
    global m1;
    global m2;
    global l1;
    global l2;
    global g;

    res = (l1/l2)*w1*w1*sin(t1-t2) - (g/l2)*sin(t2);
end



function res = g1(y)
    t1 = y(1);
    t2 = y(2);
    w1 = y(3);
    w2 = y(4);

    res = ( f1(t1,t2,w1,w2) - alpha1(t1,t2)*f2(t1,t2,w1,w2)  ) / (1 - alpha1(t1,t2)*alpha2(t1,t2));
end


function res = g2(y)
    t1 = y(1);
    t2 = y(2);
    w1 = y(3);
    w2 = y(4);

    res = ( -alpha2(t1,t2)*f1(t1,t2,w1,w2) + f2(t1,t2,w1,w2)  ) / (1 - alpha1(t1,t2)*alpha2(t1,t2));
end

