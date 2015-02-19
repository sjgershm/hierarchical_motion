function hierarchical_motion_plot(results)
    
    % Plot results.
    %
    % USAGE: hierarchical_motion_plot(results)
    
    msize = 0.4;
    figure;
    
    if isstruct(results); sim = results.sim; else sim = results; end
    
    switch sim
        case {1,6}
            x1 = results.x{1};
            x2 = results.x{2};
            clr = {'b' 'g'};
            scale = 0;
            lim = [-0.4 1.2];
            t = x2 - x1;
            subplot(2,2,1);
            for i = 1:2
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
            end
            for i = 1:2
                quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-','LineWidth',3,'MaxHeadSize',msize,'Color',[0.5 0.5 0.5],'AutoScale','off');
            end
            mytitle('A) Stimulus','Left','FontSize',18,'FontWeight','Bold');
            axis equal
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            subplot(2,2,2);
            for i = 1:2
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
            end
            mytitle('B) Percept','Left','FontSize',18,'FontWeight','Bold');
            axis equal
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            subplot(2,2,3);
            for i = 1:2
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                try
                    t = results.m{results.k_active==results.c(i,2),1};
                    quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,clr{i},'LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                end
                try
                    t = results.m{1,1};   %common motion
                    quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-r','LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                end
            end
            axis equal
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            mytitle('C) Model','Left','FontSize',18,'FontWeight','Bold');
            subplot(2,2,4);
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            axis off
            mytitle('D) Motion tree','Left','FontSize',18,'FontWeight','Bold');
            
        case {2,7,10}
            x1 = results.x{1};
            x2 = results.x{2};
            clr = {'b' 'g'};
            scale = 0;
            t = x2 - x1;
            lim = [-0.5 1.5];
            subplot(2,2,1);
            for i = 1:size(x1,1)
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-','LineWidth',3,'MaxHeadSize',msize,'Color',[0.5 0.5 0.5],'AutoScale','off');
            end
            axis equal
            set(gca,'XTick',[],'YTick',[],'XLim',lim,'YLim',lim);
            mytitle('A) Stimulus','Left','FontSize',18,'FontWeight','Bold');
            subplot(2,2,2);
            for i = 1:size(x1,1)
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
            end
            axis equal
            set(gca,'XTick',[],'YTick',[],'XLim',lim,'YLim',lim);
            mytitle('B) Percept','Left','FontSize',18,'FontWeight','Bold');
            subplot(2,2,3);
            for i = 1:size(x1,1)
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                try
                    t = results.m{results.k_active==results.c(i,2),1};
                    quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,clr{2},'LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                end
                t = results.m{1,1};   %common motion
                quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-r','LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
            end
            axis equal
            set(gca,'XTick',[],'YTick',[],'XLim',lim,'YLim',lim);
            mytitle('C) Model','Left','FontSize',18,'FontWeight','Bold');
            subplot(2,2,4);
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            axis off
            mytitle('D) Motion tree','Left','FontSize',18,'FontWeight','Bold');
            
        case {3,4,5}
            n = 0;
            for s = [4 3 5]
                load(['results/results',num2str(s)]);
                clr = {'b' 'g'};
                scale = 0;
                msize = 0.9;
                n = n + 1;
                subplot(3,2,n)
                for j = 1:length(results.x)-1
                    x1 = results.x{j};
                    x2 = results.x{j+1};
                    for i = 1:size(x1,1)
                        plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                        plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                    end
                end
                for j = 1:length(results.x)-1
                    x1 = results.x{j};
                    x2 = results.x{j+1};
                    for i = 1:size(x1,1)
                        t = x2 - x1;
                        quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-','LineWidth',3,'MaxHeadSize',msize,'Color',[0.5 0.5 0.5],'AutoScale','off');
                    end
                end
                set(gca,'XTick',[],'YTick',[],'XLim',[-1 max(x2(:,1))+1],'YLim',[min(x2(:,2))-1 max(x2(:,2))+2]);
                if n < 3; title('Stimulus','FontSize',18,'FontWeight','Bold'); end
                n = n + 1;
                subplot(3,2,n)
                for j = 1:length(results.x)-1
                    x1 = results.x{j};
                    x2 = results.x{j+1};
                    for i = 1:size(x1,1)
                        plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                        plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                    end
                end
                for j = 1:length(results.x)-1
                    x1 = results.x{j};
                    x2 = results.x{j+1};
                    for i = 1:size(x1,1)
                        try
                            t = results.m{results.k_active==results.c(i,2),j};
                            quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,clr{i},'LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                        end
                        t = results.m{1,j};   %common motion
                        quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-r','LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                    end
                end
                set(gca,'XTick',[],'YTick',[],'XLim',[-1 max(x2(:,1))+1],'YLim',[min(x2(:,2))-1 max(x2(:,2))+2]);
                if n < 3; title('Model','FontSize',18,'FontWeight','Bold'); end
            end
            spaceplots
            
        case {8,9}
            x1 = results.x{1};
            x2 = results.x{2};
            clr = {'b' 'g' 'c' 'b'};
            scale = 0;
            subplot(1,2,1);
            lim = [-0.4 1.8];
            t = x2 - x1;
            for i = 1:3
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-','LineWidth',3,'MaxHeadSize',msize,'Color',[0.5 0.5 0.5],'AutoScale','off');
            end
            mytitle('A) Stimulus','Left','FontSize',18,'FontWeight','Bold');
            axis equal
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            subplot(1,2,2);
            for i = 1:3
                plot(x1(i,1),x1(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2); hold on
                plot(x2(i,1),x2(i,2),'ok','MarkerSize',12,'MarkerFaceColor','none','LineWidth',2);
                try
                    ii = find(results.k_active==results.c(i,2));
                    t = results.m{ii,1};
                    quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,clr{ii},'LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                end
                try
                    t = results.m{1,1};   %common motion
                    quiver(x1(i,1),x1(i,2),t(i,1),t(i,2),scale,'-r','LineWidth',3,'MaxHeadSize',msize,'AutoScale','off');
                end
            end
            axis equal
            set(gca,'XTick',[],'YTick',[],'YLim',lim,'XLim',lim);
            mytitle('B) Model','Left','FontSize',18,'FontWeight','Bold');
            
        case 11
            theta = linspace(pi/4,3*pi/4,10);
            clear results
            for i=1:length(theta); results(i) = hierarchical_model_sim(11,theta(i)); end
            score = 1./(1+exp(-[results.score]));
            
            plot(theta,score,'-ok','LineWidth',3,'MarkerSize',10,'MarkerFaceColor','k');
            set(gca,'FontSize',15,'YLim',[0 1]);
            xlabel('Relative direction (rad)','FontSize',18);
            ylabel('P(transparent)','FontSize',18);
            
            subplot(1,2,2);
            plot(theta,[results.repulsion],'-ok','LineWidth',3,'MarkerSize',10,'MarkerFaceColor','k');
            set(gca,'FontSize',15);
            xlabel('Relative direction (rad)','FontSize',18);
            ylabel('Repulsion (rad)','FontSize',18);
            
        case 12
            
            subplot(1,2,1);
            x = results.x;
            t = x{2}-x{1};
            t = 2.5*t./norm(t);
            plot(x{1}(:,1),x{1}(:,2),'ok','MarkerFaceColor','k'); hold on
            quiver(x{1}(:,1),x{1}(:,2),t(:,1),t(:,2),0,'k','LineWidth',3);
            plot(x{1}(end-1:end,1),x{1}(end-1:end,2),'or','MarkerFaceColor','r');
            quiver(x{1}(end-1:end,1),x{1}(end-1:end,2),t(end-1:end,1),t(end-1:end,2),0,'r','LineWidth',3);
            text(x{1}(end-1,1)+0.1,x{1}(end-1,2)+0.1,'A','FontSize',18);
            text(x{1}(end,1)+0.1,x{1}(end,2)+0.1,'B','FontSize',18);
            set(gca,'XLim',[-0.1 6],'YLim',[-0.1 2.2],'XTickLabel',' ','YTickLabel',' ')
            mytitle('A','Left','FontSize',18,'FontWeight','Bold');
            
            subplot(1,2,2);
            k1 = results.c(end-1,2); k2 = results.c(end,2);
            a = [results.m{results.k_active==k1}(end-1,1) results.m{results.k_active==k2}(end,1)];
            bar(a); colormap bone
            set(gca,'FontSize',18,'XTickLabel',{'A' 'B'});
            ylabel('Perceived motion speed','FontSize',18);
            mytitle('B','Left','FontSize',18,'FontWeight','Bold');
            
    end