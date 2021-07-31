The following data structure is expected to be present after loading data via the ~dataset_name_loaddata command

DATASET Structure (same as produced by psychophys_data2mat, and used by psychophys_dataproc)

  INDIVIDUAL subject files - as produced by psychophys_data2mat
                             (the usual level of data to start with)

  1 - DATA matrix

        erp.data       - main data array, trial/sweeps in rows,
                         timepoints in columns

  2 - INDEX vectors - vertical vectors, same length as number of rows in erp.data.
                  Values index contents of each row in erp.data

      Critical index vectors - valid data required
        Used by several toolbox scripts:

        erp.elec       - electrode index
        erp.sweep      - trial/sweep index
                         (does not need to be continuous -- e.g. 1, 2, 5, 9, 30 is ok).

      SWEEP index vectors - identify various attributes of the sweeps
        Valid data NOT required for these (e.g. can be all zeros)

        erp.ttype      - 'trigger type' - stimulus type index
        erp.correct    - correct/incorrect response index
        erp.accept     - accept/reject trial index
        erp.rt         - reaction time index
        erp.response   - subject response index

      Optional stimulus/condition index variable for extra index vectors:

        erp.stim       - put any additional index vectors here as sub-variables.

  3 - PARAMETERS - various required parameters of the dataset

        erp.tbin            - 'trigger bin' - bin of time zero, bin of stimulus delivery
        erp.elecnames       - names of electrodes in rows, 10 chars wide (row # = elec #)
        erp.samplerate      - samplreate scalar
        erp.original_format - text field marking the binary format data was converted from
                              (e.g. when imported from Neuroscan using the ns2mat scripts,
                              the 'neuroscan-eeg' value is used for scaling NS files to uV during run)

