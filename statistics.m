function statistics(my_peaks, real_peaks)
check_1 = ismember(my_peaks,real_peaks);
check_2 = ismember(real_peaks,my_peaks);

correct_peaks = sum(check_1);
false_peaks = sum(~check_1);
missed_peaks = sum(~check_2);

accuracy = correct_peaks/(correct_peaks + missed_peaks + false_peaks);
sensitivity = correct_peaks/(correct_peaks + missed_peaks);
specificity = correct_peaks/(correct_peaks + false_peaks);

fprintf('number of correct peaks: %i\nnumber of incorrect peaks: %i\nnumber of missed peaks: %i\naccuracy: %1.3f\nsensitivity: %1.3f\nspecificity: %1.3f',...
    correct_peaks,false_peaks,missed_peaks,accuracy,sensitivity,specificity);
end