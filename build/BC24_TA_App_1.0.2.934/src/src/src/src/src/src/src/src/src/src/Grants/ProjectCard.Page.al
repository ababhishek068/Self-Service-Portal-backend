page 50459 "Project Card"
{
    Caption = 'Project Summary';
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Project));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Title';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    Caption = 'File Name';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field("Funding Agency No."; Rec."Funding Agency No.")
                {
                    Caption = 'Agreement No.';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Agreement No. field.';
                }
                field("SubAward No."; Rec."SubAward No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the SubAward No. field.';
                }
                field("Period of Performance"; Rec."Period of Performance")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Period of Performance field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field(Contractor; Rec.Contractor)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Contractor field.';
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    Caption = 'Type of Grant';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type of Grant field.';
                }
                field(Partners; Rec.Partners)
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Collaborative Grants field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    Caption = 'Project Code';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project Code field.';
                }
                field(Schools; Rec.Schools)
                {
                    Caption = 'Schools/department';
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Schools/department field.';
                }
                field(Objective; Rec.Objective)
                {
                    Caption = 'Objective';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Objective field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Principal Investigator"; Rec."Principal Investigator")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Principal Investigator field.';
                }
                field("Principal Investigator name"; Rec."Principal Investigator name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Principal Investigator name field.';
                }
                field("Project Coordinator"; Rec."Project Coordinator")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project Coordinator field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Reporting dates generated"; Rec."Reporting dates generated")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reporting dates generated field.';
                }
                field("Project Status"; Rec."Project Status")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
                field("IREC Approval"; Rec."IREC Approval")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the IREC Approval field.';
                }
                field("IREC Approval Date"; Rec."IREC Approval Date")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the IREC Approval Date field.';
                }
                field("Audit Indicator"; Rec."Audit Indicator")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Audit Indicator field.';
                }
                field("Main Sub"; Rec."Main Sub")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Main Sub field.';
                }
                field("Special Contract Provision"; Rec."Special Contract Provision")
                {
                    MultiLine = true;
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Special Contract Provision field.';
                }
                field("Justification Narration"; Rec."Justification Narration")
                {
                    Caption = 'Purpose Of Approval';
                    MultiLine = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purpose Of Approval field.';
                }
                field("Payment Methods"; Rec."Payment Methods")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Payment Methods field.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Caption = 'Budgeted Cost DCY';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budgeted Cost DCY field.';
                }
                field("Total Cost(LCY)"; Rec."Total Cost(LCY)")
                {
                    Caption = 'Budgeted Cost LCY';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budgeted Cost LCY field.';
                }
                field("Amount Awarded"; Rec."Amount Awarded")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount Awarded field.';
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Received Amount field.';
                }
                field("Disbursed Amount"; Rec."Disbursed Amount")
                {
                    Caption = 'Total Expenditure';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Expenditure field.';
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
                field("""Total Cost(LCY)""-""Committed Amount""-""Disbursed Amount"""; Rec."Total Cost(LCY)" - Rec."Committed Amount" - Rec."Disbursed Amount")
                {
                    Caption = 'Remaining Balance';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remaining Balance field.';
                }
                field("Obligated Amount"; Rec."Obligated Amount")
                {
                    Caption = 'Obligated Amount';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Obligated Amount field.';
                }
                field("Obligated Amount %"; Rec."Obligated Amount %")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Obligated Amount % field.';
                }
                field("Amount Invoiced"; Rec."Amount Invoiced")
                {
                    Caption = 'Amount Invoiced to Donor';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount Invoiced to Donor field.';
                }
                field("Allow OverExpenditure"; Rec."Allow OverExpenditure")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Allow OverExpenditure field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Prime Institution"; Rec."Prime Institution")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Prime Institution field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Approved Budget Start Date"; Rec."Approved Budget Start Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approved Budget Start Date field.';
                }
                field("Approved Budget End Date"; Rec."Approved Budget End Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approved Budget End Date field.';
                }
                field("Grant Phases"; Rec."Grant Phases")
                {
                    Caption = 'Grant Life';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Grant Life field.';
                }
                field("Alert sent"; Rec."Alert sent")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Alert sent field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Caption = 'Grant Currency Code';
                    Editable = "Currency CodeEditable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Grant Currency Code field.';

                    trigger OnValidate()
                    begin
                        CurrencyCheck;
                    end;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    Editable = "Invoice Currency CodeEditable";
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field("Financial Reporting Due Date"; Rec."Financial Reporting Due Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Financial Reporting Due Date field.';
                }
                field("Technical  Reporting Due Date"; Rec."Technical  Reporting Due Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Technical  Reporting Due Date field.';
                }
                field("Indirect Cost"; Rec."Indirect Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Indirect Cost field.';
                }
                field("Allowed Indirect Cost"; Rec."Allowed Indirect Cost")
                {
                    Caption = 'Allowed Indirect Cost %';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Allowed Indirect Cost % field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
            }
        }


    }

    actions
    {
        area(navigation)
        {
            group("W&IP")
            {
                Caption = 'W&IP';
                Visible = false;
                action("Calculate WIP")
                {
                    ApplicationArea = basic;
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    ToolTip = 'Executes the Calculate WIP action.';

                    trigger OnAction()
                    var
                        Job: Record Jobs;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    ApplicationArea = basic;
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;
                    ToolTip = 'Executes the Post WIP to G/L action.';

                    trigger OnAction()
                    var
                        Job: Record Jobs;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                    end;
                }
                action("WIP Entries")
                {
                    ApplicationArea = basic;
                    Caption = 'WIP Entries';
                    RunObject = Page "Grant WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                    ToolTip = 'Executes the WIP Entries action.';
                }
                action("WIP G/L Entries")
                {
                    ApplicationArea = basic;
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Grant WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                    ToolTip = 'Executes the WIP G/L Entries action.';
                }

                action(Resource)
                {
                    ApplicationArea = basic;
                    Caption = 'Resource';
                    RunObject = Page "Grant Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Resource action.';
                }
                action(Item)
                {
                    ApplicationArea = basic;
                    Caption = 'Item';
                    RunObject = Page "Grant Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    ApplicationArea = basic;
                    Caption = 'G/L Account';
                    RunObject = Page "Grant G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the G/L Account action.';
                }

                action("Compliance List")
                {
                    Caption = 'Compliance List';
                    ApplicationArea = basic;
                    RunObject = Page "Compliance main List";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Compliance List action.';
                }

                action("Res. &Gr. Allocated per Job")
                {
                    Caption = 'Res. &Gr. Allocated per Job';
                    ToolTip = 'Executes the Res. &Gr. Allocated per Job action.';
                    // RunObject = Page "Res. Gr. Allocated per Job";
                }
            }
            group("&Project")
            {
                Caption = '&Project';
                action(Compliance)
                {
                    ApplicationArea = basic;
                    Caption = 'Compliance';
                    Image = Task;
                    RunObject = Page "Compliance main List";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Compliance action.';
                }
                action("Close Out Check List")
                {
                    ApplicationArea = basic;
                    Caption = 'Close Out Check List';
                    Image = Task;
                    RunObject = Page "Grants Lookup Values List";
                    RunPageLink = "Grants no." = FIELD("No.");
                    ToolTip = 'Executes the Close Out Check List action.';
                }
                action("Co&mments")
                {
                    ApplicationArea = basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'Executes the Co&mments action.';
                    //  RunObject = Page "Comment Sheet";
                    // RunPageLink = "Table Name"=CONST(Job),"No."=FIELD("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Grant Task Lines")
                {
                    ApplicationArea = basic;
                    Caption = 'Component Lines';
                    ToolTip = 'Executes the Component Lines action.';

                    trigger OnAction()
                    var
                        JTLines: Page "Grant Task Lines";
                    begin
                        JTLines.SetJobNo(Rec."No.");
                        JTLines.RUN;
                    end;
                }
                action("Grant &Planning Lines")
                {
                    ApplicationArea = basic;
                    Caption = 'Activity & Planning Lines';
                    RunObject = Page "Grant Planning List";
                    RunPageLink = "Grant No." = FIELD("No.");
                    ToolTip = 'Executes the Activity & Planning Lines action.';
                }
                action(Statistics)
                {
                    ApplicationArea = basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Grant Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                separator(Separator64) { }
                action(Donors)
                {
                    ApplicationArea = basic;
                    Caption = 'Donors';
                    RunObject = Page "Project Donors";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Donors action.';
                }
                action("Partners (Contracted Institution)")
                {
                    ApplicationArea = basic;
                    Caption = 'Partners (Contracted Institution)';
                    RunObject = Page "Project Partners";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Partners (Contracted Institution) action.';
                }
                separator(Separator1102755035) { }
                action("Reporting phase schedule")
                {
                    ApplicationArea = basic;
                    Caption = 'Reporting phase schedule';
                    Image = AgreementQuote;
                    RunObject = Page "Phase Reporting SchedulesAudit";
                    RunPageLink = Project = FIELD("No.");
                    ToolTip = 'Executes the Reporting phase schedule action.';
                }
                action("Personnel Cost Alloc.")
                {
                    ApplicationArea = basic;
                    Caption = 'Personnel Cost Alloc.';
                    RunObject = Page "Project Personnel Cost Alloc";
                    RunPageLink = Project = FIELD("No.");
                    ToolTip = 'Executes the Personnel Cost Alloc. action.';
                }
                action("Change log to this Project")
                {
                    ApplicationArea = basic;
                    Caption = 'Change log to this Project';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Jobs Change Entries";
                    RunPageLink = "Project No" = FIELD("No.");
                    ToolTip = 'Executes the Change log to this Project action.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Approvals action.';
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                    end;
                }
                separator(Separator1102755018) { }
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Send for Approval action.';
                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        varvariant: Variant;
                    begin
                        varvariant := rec;
                        //Release the grant for Approval

                        //TESTFIELD(Donors);
                        //TESTFIELD("Total Cost");
                        //TESTFIELD("Bill-to Partner No.");

                        ///IF NOT RecordLinkCheck(Rec) THEN ERROR('You have no documents attached hence cant proceed');

                        ApprovalMgt.OnSendDocForApproval(varvariant);  //
                        //IF ApprovalMgt.SendLabRequestApprovalReq(Rec) THEN;   //
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = basic;
                    Caption = 'Cancel Approval Request';
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        varvariant: Variant;
                    begin
                        varvariant := rec;
                        ApprovalMgt.OnCancelDocApprovalRequest(varvariant);
                    end;
                }
                separator(Separator1102755020) { }
            }
        }
        area(reporting)
        {
            action("Project Summary Sheet")
            {
                Caption = 'Project Summary Sheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunPageOnRec = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the Project Summary Sheet action.';
                trigger OnAction()
                begin
                    //      Report project Summary Sheet
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134739, TRUE, TRUE, objJobs);
                end;
            }
            action("Project FactSheet")
            {
                Caption = 'Project FactSheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = basic;
                ToolTip = 'Executes the Project FactSheet action.';
                trigger OnAction()
                begin
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134994, TRUE, TRUE, objJobs);
                end;
            }
            action("Grant Financial Report")
            {
                Caption = 'Grant Financial Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = basic;
                ToolTip = 'Executes the Grant Financial Report action.';
                trigger OnAction()
                begin
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134996, TRUE, TRUE, objJobs);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        "Currency CodeEditable" := TRUE;
        "Invoice Currency CodeEditable" := TRUE;
        Rec.Status := Rec.Status::Project;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;

        Rec.Status := Rec.Status::Project;
    end;

    trigger OnOpenPage()
    begin
        /*IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;*/

        //IF NOT MapMgt.TestSetup THEN
        //  CurrForm.MapPoint.VISIBLE(FALSE);

        CurrencyCheck;

    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        objJobs: Record Jobs;

    procedure CurrencyCheck()
    begin
        IF Rec."Currency Code" <> '' THEN
            "Invoice Currency CodeEditable" := FALSE
        ELSE
            "Invoice Currency CodeEditable" := TRUE;

        IF Rec."Invoice Currency Code" <> '' THEN
            "Currency CodeEditable" := FALSE
        ELSE
            "Currency CodeEditable" := TRUE;
    end;

    procedure RecordLinkCheck(job: Record Jobs) RecordLnkExist: Boolean
    var
        objRecordLnk: Record "Record Link";
        TableCaption: RecordID;
        objRecord_Link: RecordRef;
    begin
        objRecord_Link.GETTABLE(job);
        TableCaption := objRecord_Link.RECORDID;
        objRecordLnk.RESET;
        objRecordLnk.SETRANGE(objRecordLnk."Record ID", TableCaption);
        IF objRecordLnk.FIND('-') THEN EXIT(TRUE) ELSE EXIT(FALSE);
    end;
}

