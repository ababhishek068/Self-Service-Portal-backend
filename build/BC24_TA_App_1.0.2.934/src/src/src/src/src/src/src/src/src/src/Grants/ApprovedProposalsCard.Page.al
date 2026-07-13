page 51266 "Approved Proposals Card"
{
    Caption = ' Approved Interactive Proposal Development Card';
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Proposal), "Approval Status" = FILTER(Approved));
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
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Submission; Rec.Submission)
                {
                    ToolTip = 'Specifies the value of the Submission field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Principal Investigator"; Rec."Principal Investigator")
                {
                    ToolTip = 'Specifies the value of the Principal Investigator field.';
                }
                field("Principal Investigator name"; Rec."Principal Investigator name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Principal Investigator name field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(Schools; Rec.Schools)
                {
                    Caption = 'Schools';
                    ToolTip = 'Specifies the value of the Schools field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title of the marketing activity field.';
                }
                field(Objective; Rec.Objective)
                {
                    Caption = ' Brief Description Of the Program';
                    ToolTip = 'Specifies the value of the  Brief Description Of the Program field.';
                }
                field("Bill-to Partner No."; Rec."Bill-to Partner No.")
                {
                    Caption = 'Major Donor';
                    ToolTip = 'Specifies the value of the Major Donor field.';
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field("PI Name"; Rec."PI Name")
                {
                    ToolTip = 'Specifies the value of the PI At Collaborative Institution field.';
                }
                field("PI Address"; Rec."PI Address")
                {
                    ToolTip = 'Specifies the value of the PI Address field.';
                }
                field("PI Telephone"; Rec."PI Telephone")
                {
                    ToolTip = 'Specifies the value of the PI Telephone field.';
                }
                field("PI EMail"; Rec."PI EMail")
                {
                    ToolTip = 'Specifies the value of the PI EMail field.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ToolTip = 'Specifies the value of the Search Description field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Concept Approval Date"; Rec."Concept Approval Date")
                {
                    ToolTip = 'Specifies the value of the Concept Approval Date field.';
                }
                field("Main Sub"; Rec."Main Sub")
                {
                    ToolTip = 'Specifies the value of the Main Sub field.';
                }
                field("IREC Approval"; Rec."IREC Approval")
                {
                    ToolTip = 'Specifies the value of the IREC Approval field.';
                }
                field("IREC Approval Date"; Rec."IREC Approval Date")
                {
                    ToolTip = 'Specifies the value of the IREC Approval Date field.';
                }
                field("Cost Share"; Rec."Cost Share")
                {
                    ToolTip = 'Specifies the value of the Cost Share field.';
                }
                field("Cost Share Details"; Rec."Cost Share Details")
                {
                    ToolTip = 'Specifies the value of the Cost Share Details field.';
                }
                field(Matching; Rec.Matching)
                {
                    ToolTip = 'Specifies the value of the Matching field.';
                }
                field("Matching Details"; Rec."Matching Details")
                {
                    ToolTip = 'Specifies the value of the Matching Details field.';
                }
                field("Funding Request"; Rec."Funding Request")
                {
                    ToolTip = 'Specifies the value of the Funding Request field.';
                }
                field(Budget; Rec.Budget)
                {
                    ToolTip = 'Specifies the value of the Budget field.';
                }
                field("Budget Justification"; Rec."Budget Justification")
                {
                    ToolTip = 'Specifies the value of the Budget Justification field.';
                }
                field("Project Summary Abstract"; Rec."Project Summary Abstract")
                {
                    ToolTip = 'Specifies the value of the Project Summary Abstract field.';
                }
                field("RSPO Completion List"; Rec."RSPO Completion List")
                {
                    ToolTip = 'Specifies the value of the RSPO Completion List field.';
                }
                field(Control42; Rec.Partners)
                {
                    ShowCaption = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Project Status';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Responsible Officer"; Rec."Responsible Officer")
                {
                    ToolTip = 'Specifies the value of the Responsible Officer field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Funding Agency';
                    ToolTip = 'Specifies the value of the Funding Agency field.';
                }
                field("Proposal Application due Date"; Rec."Proposal Application due Date")
                {
                    ToolTip = 'Specifies the value of the Proposal Application due Date field.';
                }
                field("RFA/A Receipt Date"; Rec."RFA/A Receipt Date")
                {
                    ToolTip = 'Specifies the value of the RFA/A Receipt Date field.';
                }
                field("Project Team"; Rec."Project Team")
                {
                    ToolTip = 'Specifies the value of the Project Team field.';
                }
            }
            group("New Study Description  Page")
            {
                Caption = 'New Study Description  Page';
                part("Areas involved in this project"; "Project/Proposal Area")
                {
                    Caption = 'Areas involved in this project';
                    SubPageLink = "Proposal No." = FIELD("No.");
                }
                field("Moi/MTRH Collaborator"; Rec."Moi/MTRH Collaborator")
                {
                    ToolTip = 'Specifies the value of the Do you have a previous Collaboration with Moi/MTRH ? field.';
                }
                field("AMPATH Affiliation Consortium"; Rec."AMPATH Affiliation Consortium")
                {
                    ToolTip = 'Specifies the value of the AMPATH Affiliation Consortium field.';
                }
                field("Previous MU Consortium School?"; Rec."Previous MU Consortium School?")
                {
                    ToolTip = 'Specifies the value of the Previous MU Consortium School? field.';
                }
                field("Which MU Consortium School"; Rec."Which MU Consortium School")
                {
                    ToolTip = 'Specifies the value of the Which MU Consortium School field.';
                }
                field("ASANTE Collaborator?"; Rec."ASANTE Collaborator?")
                {
                    ToolTip = 'Specifies the value of the ASANTE Collaborator? field.';
                }
                field("ASANTE Collaborator Details"; Rec."ASANTE Collaborator Details")
                {
                    ToolTip = 'Specifies the value of the ASANTE Collaborator Details field.';
                }
                field("Assist identifying Collabotor?"; Rec."Assist identifying Collabotor?")
                {
                    ToolTip = 'Specifies the value of the Assist identifying Collabotor? field.';
                }
                field("Study Type"; Rec."Study Type")
                {
                    ToolTip = 'Specifies the value of the Study Type field.';
                }
                field("Study Type Details"; Rec."Study Type Details")
                {
                    ToolTip = 'Specifies the value of the Study Type Details field.';
                }
                field("Brief Description of Study"; Rec."Brief Description of Study")
                {
                    ToolTip = 'Specifies the value of the Brief Description of Study field.';
                }
                field("Study Funded"; Rec."Study Funded")
                {
                    ToolTip = 'Specifies the value of the Study Funded field.';
                }
                field("Funding Source/Funding Sought"; Rec."Funding Source/Funding Sought")
                {
                    ToolTip = 'Specifies the value of the Funding Source/Funding Sought field.';
                }
                field("Application Deadline"; Rec."Application Deadline")
                {
                    ToolTip = 'Specifies the value of the Application Deadline field.';
                }
                field("Lab Services"; Rec."Lab Services")
                {
                    ToolTip = 'Specifies the value of the Lab Services field.';
                }
                field("AMPATH Data Mgt Core Required"; Rec."AMPATH Data Mgt Core Required")
                {
                    ToolTip = 'Specifies the value of the AMPATH Data Mgt Core Required field.';
                }
                field("Contracted To"; Rec."Contracted To")
                {
                    ToolTip = 'Specifies the value of the Contracted To field.';
                }
                field("Biostats Core Required"; Rec."Biostats Core Required")
                {
                    ToolTip = 'Specifies the value of the Biostats Core Required field.';
                }
                field("Prime Institution"; Rec."Prime Institution")
                {
                    ToolTip = 'Specifies the value of the Prime Institution field.';
                }
                field("Workgroup Recomendation"; Rec."Workgroup Recomendation")
                {
                    ToolTip = 'Specifies the value of the Workgroup Recomendation field.';
                }
                field("Recomendation Description"; Rec."Recomendation Description")
                {
                    ToolTip = 'Specifies the value of the Recomendation Description field.';
                }
            }
            group("Lab Request Page")
            {
                Caption = 'Lab Request Page';
                part(Control6; "Lab Request Form")
                {
                    SubPageLink = "Proposal No." = FIELD("No.");
                }
            }
        }
        area(factboxes)
        {
            systempart(Control4; Links) { }
            systempart(Control2; Notes) { }
            systempart(Control1; MyNotes) { }
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
                    Caption = 'WIP Entries';
                    RunObject = Page "Grant WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                    ToolTip = 'Executes the WIP Entries action.';
                }
                action("WIP G/L Entries")
                {
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
                    RunObject = Page "Grant Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Resource action.';
                }
                action(Item)
                {
                    Caption = 'Item';
                    RunObject = Page "Grant Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
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
                    ToolTip = 'Executes the Proposal Check List action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job), "No." = FIELD("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Grant Task Lines")
                {
                    Caption = 'Grant Task Lines';
                    RunObject = Page "Grant Task Lines";
                    RunPageLink = "Grant No." = FIELD("No.");
                    ToolTip = 'Executes the Grant Task Lines action.';
                }
                action("Grant &Planning Lines")
                {
                    Caption = 'Grant &Planning Lines';
                    RunObject = Page "Grant Planning List";
                    RunPageLink = "Grant No." = FIELD("No.");
                    ToolTip = 'Executes the Grant &Planning Lines action.';
                }
                action(Statistics)
                {
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
                action("Online Map")
                {
                    Caption = 'Online Map';
                    ToolTip = 'Executes the Online Map action.';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                separator(Separator1102755008) { }
                action(Partners)
                {
                    Caption = 'Partners';
                    RunObject = Page "Project Partners";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Partners action.';
                }
                action(Donors)
                {
                    Caption = 'Donors';
                    RunObject = Page "Project Donors";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Donors action.';
                }
                separator(Separator1102755019) { }
                action("Personnel Cost Alloc.")
                {
                    Caption = 'Personnel Cost Alloc.';
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
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition",JV,"Grant Task","Concept Note",Proposal;
                    begin
                        DocumentType := DocumentType::Proposal;
                        ApprovalEntries.SetRecordFilters(DATABASE::Jobs, DocumentType, Rec."No.");
                        ApprovalEntries.RUN;
                    end;
                }
                separator(Separator1102755018) { }
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        varVarint: Variant;
                    begin
                        //Release the grant for Approval
                        //TESTFIELD("Total Cost");
                        varVarint := REC;
                        ApprovalMgt.OnSendDocForApproval(varVarint);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        varVarint: Variant;
                    begin
                        //Release the grant for Approval
                        //TESTFIELD("Total Cost");
                        varVarint := REC;
                        ApprovalMgt.OnCancelDocApprovalRequest(varVarint);
                    end;
                }
                separator(Separator1102755020) { }

                action("Revert to Concept")
                {
                    Caption = 'Revert to Concept';
                    ToolTip = 'Executes the Revert to Concept action.';

                    trigger OnAction()
                    begin
                        // Status:=Status::"Concept Formulation";
                        // MODIFY;


                        //IF "Approval Status"= "Approval Status"::Open THEN ERROR('Concept must be approved first');
                        IF CONFIRM('Revert proposal to concept?') THEN BEGIN
                            Rec.Status := Rec.Status::"Concept Formulation";
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.MODIFY
                        END
                    end;
                }
                action("Convert to Contract")
                {
                    Caption = 'Convert to Contract';
                    ToolTip = 'Executes the Convert to Contract action.';

                    trigger OnAction()
                    begin
                        IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN Rec.ChangeProjectStatus;
                    end;
                }
                action(recordlinks)
                {
                    Caption = 'recordlinks';
                    ToolTip = 'Executes the recordlinks action.';

                    trigger OnAction()
                    begin
                        objNewJob.RESET;
                        objNewJob.SETRANGE(objNewJob."No.", Rec."System Contract No");
                        IF objNewJob.FIND('-') THEN
                            Rec.RecordLinkMove(Rec, objNewJob);
                    end;
                }
                action(Open)
                {
                    Caption = 'Open';
                    ShortCutKey = 'Return';
                    ToolTip = 'Executes the Open action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Convert proposal to contract?') THEN BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.MODIFY;
                        END
                    end;
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
                    //      Report project Summary Sheet
                    objjobs.RESET;
                    objjobs.SETRANGE(objjobs."No.", Rec."No.");
                    IF objjobs.FIND('-') THEN
                        REPORT.RUN(70134750, TRUE, TRUE, objjobs);
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
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;

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
        objNewJob: Record Jobs;
        objjobs: Record Jobs;

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
}

