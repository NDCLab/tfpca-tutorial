msgboxText = ['EEG variable is not a structure but an object.\n\n'...
        'Unfortunately, ERPLAB has not been fully tested using this Matlab class.\n\n'...
        'HINT: You may go to the EEGLAB''s "File" menu, then "Memory and other options" and '...
        'disable the checkbox that says "If set, use the EEGLAB EEG object instead of the standard EEG structure..."'];
title = 'ERPLAB: EEG variable is not a structure.';
errorfound(sprintf(msgboxText), title);