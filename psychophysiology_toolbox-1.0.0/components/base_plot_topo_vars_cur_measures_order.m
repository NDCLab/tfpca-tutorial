% Psychophysiology Toolbox, Components, University of Minnesota  

    switch runtype
    case {'pcatfd','wintfd'},
      for q=1:length(cur_measures),
        t=char(cur_measures(q));
        switch t(end)
        case 'm', cur_measures_order(q).num = 1; cur_measures_order(q).text = 'Mean';
        case 'p', cur_measures_order(q).num = 2; cur_measures_order(q).text = 'Peak';
        case 't', cur_measures_order(q).num = 3; cur_measures_order(q).text = 'Time';
        case 'f', cur_measures_order(q).num = 4; cur_measures_order(q).text = 'Freq.';
        case 'd', cur_measures_order(q).num = 5; cur_measures_order(q).text = 'Median';
        end
      end
    case {'pca',   'win'},
      for q=1:length(cur_measures),
        t=char(cur_measures(q));
        switch t(end)
        case 'm', cur_measures_order(q).num = 1; cur_measures_order(q).text = 'Mean';
        case 'p', cur_measures_order(q).num = 2; cur_measures_order(q).text = 'Peak';
        case 'l', cur_measures_order(q).num = 3; cur_measures_order(q).text = 'Latency';
        case 'd', cur_measures_order(q).num = 4; cur_measures_order(q).text = 'Median';
        end
      end
    end

