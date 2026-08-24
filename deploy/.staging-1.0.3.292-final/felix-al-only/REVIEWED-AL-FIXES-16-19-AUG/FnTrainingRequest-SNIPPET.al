// SNIPPET — paste into FnTrainingRequest in StaffPortalCodeunit.Codeunit.al
// Location: after Training Header is Init/Insert and fields are assigned, before Modify()

        // HIJRA-2026-07-25: Portal lists training by Employee No. on the HEADER.
        // Older FnTrainingRequest only added participant lines — new drafts had blank
        // Employee No. and were filtered out of QyTrainingApplicationHeader.
        if TrainingHeader."Employee No." = '' then
            TrainingHeader."Employee No." := EmployeeNo;
