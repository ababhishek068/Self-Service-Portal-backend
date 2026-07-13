page 50319 "Proposal Card"
{
    Caption = 'Interactive Proposal Development Card';

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Proposal), "Approval Status" = FILTER(Open | "Pending Approval"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Route Sheet")
            {
                Caption = 'Route Sheet';
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
                field(Submission; Rec.Submission)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Submission field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    Caption = 'Title';
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Principal Investigator"; Rec."Principal Investigator")
                {
                    ApplicationArea = basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Principal Investigator field.';
                }
                field("Principal Investigator name"; Rec."Principal Investigator name")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Principal Investigator name field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    ApplicationArea = basic;
                    caption = 'Dim1 Code';
                    ToolTip = 'Specifies the value of the Dim1 Code field.';
                }
                field(Schools; Rec.Schools)
                {
                    ApplicationArea = basic;
                    Caption = 'Schools';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Schools field.';
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = basic;
                    Caption = ' Brief Description Of the Program';
                    ToolTip = 'Specifies the value of the  Brief Description Of the Program field.';
                }
                field("Bill-to Partner No."; Rec."Bill-to Partner No.")
                {
                    ApplicationArea = basic;
                    Caption = ' Donor';
                    ToolTip = 'Specifies the value of the  Donor field.';
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field("PI Name"; Rec."PI Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the PI At Collaborative Institution field.';
                }
                field("PI Address"; Rec."PI Address")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the PI Address field.';
                }
                field("PI Telephone"; Rec."PI Telephone")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the PI Telephone field.';
                }
                field("PI EMail"; Rec."PI EMail")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the PI EMail field.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Search Description field.';
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
                field("Concept Approval Date"; Rec."Concept Approval Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Concept Approval Date field.';
                }
                field("Main Sub"; Rec."Main Sub")
                {
                    ApplicationArea = basic;
                    Caption = ' Sub';
                    Visible = false;
                    ToolTip = 'Specifies the value of the  Sub field.';
                }
                field("IREC Approval"; Rec."IREC Approval")
                {
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the IREC Approval field.';
                }
                field("Proposal Status"; Rec."Proposal Status")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Proposal Status field.';
                }
                field("IREC Approval Date"; Rec."IREC Approval Date")
                {
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the IREC Approval Date field.';
                }
                field("Cost Share"; Rec."Cost Share")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Share field.';
                }
                field("Cost Share Details"; Rec."Cost Share Details")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Share Details field.';
                }
                field(Matching; Rec.Matching)
                {
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Matching field.';
                }
                field("Matching Details"; Rec."Matching Details")
                {
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Matching Details field.';
                }
                field("Funding Request"; Rec."Funding Request")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Funding Request field.';
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budget field.';
                }
                field("Budget Justification"; Rec."Budget Justification")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budget Justification field.';
                }
                field("Project Summary Abstract"; Rec."Project Summary Abstract")
                {
                    ApplicationArea = basic;
                    Caption = 'Project Summary Abstract';
                    ToolTip = 'Specifies the value of the Project Summary Abstract field.';
                }
                field("RSPO Completion List"; Rec."RSPO Completion List")
                {
                    ApplicationArea = basic;
                    Caption = 'Other Application Requirements';
                    ToolTip = 'Specifies the value of the Other Application Requirements field.';
                }
                field(Control1102755008; Rec.Partners)
                {
                    ApplicationArea = basic;
                    ShowCaption = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    // Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    Caption = 'Project Status';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Responsible Officer"; Rec."Responsible Officer")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Responsible Officer field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Funding Agency';
                    ToolTip = 'Specifies the value of the Funding Agency field.';
                }
                field("Proposal Application due Date"; Rec."Proposal Application due Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Proposal Application due Date field.';
                }
                field("RFA/A Receipt Date"; Rec."RFA/A Receipt Date")
                {
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the RFA/A Receipt Date field.';
                }
                field("Project Team"; Rec."Project Team")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project Team field.';
                }
                field("Indirect Cost"; Rec."Indirect Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Indirect Cost field.';
                }
                field("Allowed Indirect Cost"; Rec."Allowed Indirect Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Allowed Indirect Cost field.';
                }
            }
        }
        area(factboxes)
        {


            systempart(Control1900383207; Links)
            {
                Caption = 'Attachments';
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
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
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    ApplicationArea = basic;
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
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;
                    ApplicationArea = basic;
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
            }
            group("&Prices")
            {
                Caption = '&Prices';
                Visible = false;

                action(Resource)
                {
                    Caption = 'Resource';
                    ApplicationArea = basic;
                    RunObject = Page "Grant Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Resource action.';
                }
                action(Item)
                {
                    Caption = 'Item';
                    ApplicationArea = basic;
                    RunObject = Page "Grant Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    ApplicationArea = basic;
                    RunObject = Page "Grant G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the G/L Account action.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Visible = false;
                action("Resource Allocated per Job")
                {
                    ApplicationArea = basic;
                    Caption = 'Resource Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'Executes the Resource Allocated per Job action.';
                }
                separator(a)
                {
                    Caption = 'a';
                }
                action("Res. &Gr. Allocated per Job")
                {
                    Caption = 'Res. &Gr. Allocated per Job';
                    ApplicationArea = basic;
                    RunObject = Page "Res. Gr. Allocated per Job";
                    ToolTip = 'Executes the Res. &Gr. Allocated per Job action.';
                }
            }
            group("&Proposal")
            {
                Caption = '&Proposal';
                action("Page Proposal Check List")
                {
                    Caption = 'Proposal Check List';
                    ApplicationArea = basic;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Proposal Check List";
                    RunPageLink = "Proposal Code" = FIELD("No.");
                    ToolTip = 'Executes the Proposal Check List action.';
                }
                action("Area")
                {
                    Caption = 'Area';
                    ToolTip = 'Executes the Area action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ApplicationArea = basic;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job), "No." = FIELD("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }

                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    ApplicationArea = basic;
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Grant Task Lines")
                {
                    Caption = 'Grant Task Lines';
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Grant Task Lines action.';
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
                    Caption = 'Grant &Planning Lines';
                    ApplicationArea = basic;
                    RunObject = Page "Grant Planning List";
                    RunPageLink = "Grant No." = FIELD("No.");
                    ToolTip = 'Executes the Grant &Planning Lines action.';
                }
                action("Compliance List")
                {
                    Caption = 'Compliance List';
                    ApplicationArea = basic;
                    RunObject = Page "Compliance main List";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Compliance List action.';
                }

                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    ApplicationArea = basic;
                    PromotedCategory = Process;
                    RunObject = Page "Grant Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                separator(Separator64) { }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    ToolTip = 'Executes the Online Map action.';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                separator(Separator1102755026) { }
                action(Partners)
                {
                    Caption = 'Partners';
                    RunObject = Page "Project Partners";
                    ApplicationArea = basic;
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Partners action.';
                }
                action(Donors)
                {
                    Caption = 'Donors';
                    ApplicationArea = basic;
                    RunObject = Page "Project Donors";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Donors action.';
                }
                separator(Separator1102755017) { }
                action("Personnel Cost Alloc.")
                {
                    Caption = 'Personnel Cost Alloc.';
                    ApplicationArea = basic;
                    RunObject = Page "Project Personnel Cost Alloc";
                    RunPageLink = Project = FIELD("No.");
                    ToolTip = 'Executes the Personnel Cost Alloc. action.';
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
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Send Approval Request action.';
                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        varVar: Variant;
                    begin
                        varVar := rec;
                        Rec.TESTFIELD("Bill-to Partner No.");

                        IF Rec."Cost Share" = TRUE THEN BEGIN
                            Rec.CALCFIELDS(Donors);
                            Rec.TESTFIELD(Donors);
                        END;

                        // IF NOT RecordLinkCheck(Rec) THEN ERROR('You have no documents attached hence cant proceed');

                        ApprovalMgt.OnSendDocForApproval(varVar);
                        Rec.Status := Rec.Status::Contract;
                        Rec.MODIFY;
                        MESSAGE('Proposal fully approved and converted to contract');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Cancel Approval Request action.';
                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        VarVar: Variant;
                    begin
                        VarVar := Rec;
                        ApprovalMgt.OnCancelDocApprovalRequest(varvar);

                    end;
                }
                separator(Separator1102755020) { }

                action("Revert to Concept")
                {
                    Caption = 'Revert to Concept';
                    ToolTip = 'Executes the Revert to Concept action.';

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Proposal;
                        Rec.MODIFY;
                    end;
                }
                action("New study information")
                {
                    Caption = 'New study information';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = Page "New study form page";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageMode = Create;
                    Visible = false;
                    ToolTip = 'Executes the New study information action.';
                }
                action("View study information")
                {
                    Caption = 'View study information';
                    Image = card;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = Page "New study form page";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageMode = Edit;
                    Visible = false;
                    ToolTip = 'Executes the View study information action.';
                }
                action("New Lab Request Form")
                {
                    Caption = 'New Lab Request Form';
                    Image = card;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = Page "Lab request form new";
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = false;
                    ToolTip = 'Executes the New Lab Request Form action.';
                }
            }
        }
        area(reporting)
        {
            action("Proposal Route Sheet")
            {
                Caption = 'Proposal Route Sheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunPageOnRec = true;
                ToolTip = 'Executes the Proposal Route Sheet action.';

                trigger OnAction()
                begin
                    //      Proposal route sheet
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134750, TRUE, TRUE, objJobs);
                end;
            }
            action("New Study Form")
            {
                Caption = 'New Study Form';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunPageOnRec = true;
                Visible = false;
                ToolTip = 'Executes the New Study Form action.';

                trigger OnAction()
                begin
                    //      New study form
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134752, TRUE, TRUE, objJobs);
                end;
            }
            action("Lab Request Form")
            {
                Caption = 'Lab Request Form';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunPageOnRec = true;
                Visible = false;
                ToolTip = 'Executes the Lab Request Form action.';

                trigger OnAction()
                begin
                    //      Report Lab request form
                    objJobs.RESET;
                    objJobs.SETRANGE(objJobs."No.", Rec."No.");
                    IF objJobs.FIND('-') THEN
                        REPORT.RUN(70134753, TRUE, TRUE, objJobs);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        "Currency CodeEditable" := TRUE;
        "Invoice Currency CodeEditable" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        Rec.Status := Rec.Status::Proposal;
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;
        */
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

