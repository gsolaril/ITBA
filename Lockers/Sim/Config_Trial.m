%% ========== Import System variables

DATABASE = evalin('base','DATABASE');
num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

%% ========== Date trial

date_now = datevec(now);
date_now = date_now(1:3);
date_exp = DATABASE(num_regz,3:5);

date_now = datenum(date_now);
date_exp = datenum(date_exp);

if (date_now <= date_exp + 10)
    let = 1;
else
    let = 0;
end

%% ========== Export System variables

assignin('base','let',let)