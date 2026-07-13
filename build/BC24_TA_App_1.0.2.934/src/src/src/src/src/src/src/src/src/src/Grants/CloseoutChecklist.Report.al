Report 50126 "Close out Checklist"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CloseoutChecklist.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Close Out Check List"; "Close Out Check List")
        {
            RequestFilterFields = "Closeout No.";
            column(ReportForNavId_1000000000; 1000000000) { }
            column(GrantNo_CloseOutCheckList; "Close Out Check List"."Grant No") { }
            column(ComplianceCode_CloseOutCheckList; "Close Out Check List"."Compliance Code") { }
            column(Description_CloseOutCheckList; "Close Out Check List".Description) { }
            column(Compliance_CloseOutCheckList; "Close Out Check List".Compliance) { }
            column(User_CloseOutCheckList; "Close Out Check List".User) { }
            column(Amount_CloseOutCheckList; "Close Out Check List".Amount) { }
            column(Comments_CloseOutCheckList; "Close Out Check List".Comments) { }
            column(Status_CloseOutCheckList; "Close Out Check List".Status) { }
            column(CloseoutNo_CloseOutCheckList; "Close Out Check List"."Closeout No.") { }
            column(ResponsibilityCenter_CloseOutCheckList; "Close Out Check List"."Responsibility Center") { }
            column(NoSeries_CloseOutCheckList; "Close Out Check List"."No. Series") { }
            column(DonorSponsorCode_CloseOutCheckList; "Close Out Check List"."Donor/Sponsor Code") { }
            column(Subcontractorno_CloseOutCheckList; "Close Out Check List"."Subcontractor no") { }
            column(Date_CloseOutCheckList; "Close Out Check List".Date) { }
            column(Subcontractor_CloseOutCheckList; "Close Out Check List".Subcontractor) { }
            column(PI_CloseOutCheckList; "Close Out Check List".PI) { }
            column(PIName_CloseOutCheckList; "Close Out Check List"."PI Name") { }
            dataitem("Closeout Checklist Lines"; "Closeout Checklist Lines")
            {
                DataItemLink = "Closeout Nos" = field("Closeout No.");
                column(ReportForNavId_1000000018; 1000000018) { }
                column(LineNo_CloseoutChecklistLines; "Closeout Checklist Lines"."Line No") { }
                column(CloseoutNos_CloseoutChecklistLines; "Closeout Checklist Lines"."Closeout Nos") { }
                column(Sections_CloseoutChecklistLines; "Closeout Checklist Lines".Sections) { }
                column(Options_CloseoutChecklistLines; "Closeout Checklist Lines".Options) { }
                column(Amount_CloseoutChecklistLines; "Closeout Checklist Lines".Amount) { }
                column(Reason_CloseoutChecklistLines; "Closeout Checklist Lines".Reason) { }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

