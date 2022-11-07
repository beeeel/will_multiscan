%[FM_data] = Func_fit_data_values_multiscan(data,FM_params)
%uses fminsearch to fit a decaying exponential to the data;
%assume only one freq component in the trace
%uses range of data.pro supplied by FM_params.range

function [FM_data] = func_fit_data_values_multiscan(data,axis_info,FM_params)
disp('Time domain fitting starting')
if isfield(FM_params,'FM_scans') && ~isempty(FM_params.FM_scans)
    sIs = FM_params.FM_scans;
else
    sIs = 1:axis_info.number_of_scans ;
end

FM_data = struct('scan_idxs',sIs);

for sI = sIs
    sc = sprintf('scan%i',sI);
    fprintf('Starting FMA for %s\n', sc)
    for L=1:length(data.(sc).ac);
        d =1e9* data.(sc).t_out{1}(FM_params.range)';
        FM_data.(sc).t = d;
        %% %%%%%%%%%%
        jMax = max(axis_info.(sc).axis_pts(2:end)); %%%%%%%%%%%%%
        for j =1:jMax
            if (j==1)||(rem(j,10)==0)
                fprintf('%i / %i \r', j, jMax)
            end
            for k =1:axis_info.(sc).axis_pts(1);
                to_fit = 1000*squeeze(data.(sc).pro{L}(k,j,FM_params.range));
                
                f = data.(sc).freq{L}(k,j);
                A = 0;
                B = 1000*data.(sc).f_amp{L}(k,j);
                alpha = 1;
                phi =pi/2;
                param_guess = [A  B f alpha phi]; % input parameters for fitfun_gauss: [height width centre]
                options=optimset('fminsearch');
                options = optimset(options,'Display','off','MaxFunEvals',5000);
                [pars,fval,exitflag,output]=fminsearch(@(guess)fitfun_decay_sin_with_plottest(guess,d,to_fit),param_guess,options);
                FM_data.(sc).A{L}(k,j) = pars(1);
                FM_data.(sc).amp{L}(k,j) = pars(2);
                FM_data.(sc).freq{L}(k,j) = pars(3);
                FM_data.(sc).alpha{L}(k,j) = pars(4);
                FM_data.(sc).phi{L}(k,j) = pars(5);
                FM_data.(sc).fval{L}(k,j) = fval;
                FM_data.(sc).exit{L}(k,j) = exitflag;
                FM_data.(sc).fncount{L}(k,j) = output.funcCount;
                FM_data.(sc).itcount{L}(k,j) = output.iterations;
                %build aray of error residuals.
                A1 = pars(1);
                B1 = pars(2);
                C1 = pars(3);
                D1 = pars(4);
                E1 = pars(5);
                fitted = A1+B1.*sin(2*pi*C1*d+E1).*exp(-D1*d);
                FM_data.(sc).residuals{L}(k,j,:) = to_fit - fitted;
                FM_data.(sc).traces_fit{L}(k,j,:) = fitted;
                FM_data.(sc).data_array{L}(k,j,:) =to_fit;
                
            end
        end
    end
end
disp('Time domain fitting Finished')