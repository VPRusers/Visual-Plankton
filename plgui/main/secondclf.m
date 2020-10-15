function [aids,neuron] = secondclf(fea, meas, taxa, dir_autoid, day, hour, roiname, clfid);

taxa
com = ['global ',taxa, '_t1;', 't1 = ' taxa, '_t1;' ]; eval(com); 
com = ['global ',taxa, '_t2;', 't2 = ' taxa, '_t2;']; eval(com);  
com = ['global ',taxa, '_t3;', 't3 = ' taxa, '_t3;']; eval(com); 
com = ['global ',taxa, '_t4;', 't4 = ' taxa, '_t4;']; eval(com); 
com = ['global ',taxa, '_faxis_max;', 'faxis_max = ' taxa, '_faxis_max;']; 
eval(com); 
com = ['global ',taxa,'_select_type; ', 'select_type = ' taxa,'_select_type;'];
eval(com); 
com = ['global ',taxa, '_cl_method;', 'cl_method = ' taxa, '_cl_method;']; 
eval(com); 
com = ['global ',taxa, '_x_mean;', 'x_mean = ' taxa, '_x_mean;']; eval(com); 
com = ['global ',taxa, '_x_std;', 'x_std = ' taxa, '_x_std;']; eval(com); 
com = ['global ',taxa, '_taxas;', 'taxas = ' taxa, '_taxas;']; eval(com); 
a = '0';
    [aids, neuron] = clf_real(fea, faxis_max, select_type, ...
	t1, t2, t3, t4, cl_method, x_mean, x_std);
if meas
    taxastr = deblank(taxas(aids,:));
    fil_nam = [dir_autoid, taxastr, '/aid/',clfid, 'aid.d', day, '.h', ...
		a(2-length(num2str(hour))), num2str(hour) ];
    fea_mea = [dir_autoid,taxastr, '/aidmea/',clfid, 'aid.mea.d', day,'.h', ...
		a(2-length(num2str(hour))), num2str(hour)];

    fid_nam = fopen(fil_nam, 'a');
    fid_mea = fopen(fea_mea, 'a');
    fprintf(fid_nam, '%s\n', roiname);         % **
    fprintf(fid_mea, '%9.4f %9.4f %9.4f %9.4f %9.4f %9.4f %9.4f\n', ...
			meas);
    fclose(fid_nam);
    fclose(fid_mea);  
end