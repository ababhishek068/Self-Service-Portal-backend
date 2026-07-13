page 50963 "Marketting Card"
{
    Caption = 'Marketting Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Market), "Approval Status" = FILTER(Open | "Pending Approval"));
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
                    Caption = 'No.';
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


                field(Objective; Rec.Objective)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Main Objective field.';
                }

                field("Specific Objective"; Rec."Specific Objective")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Specific Objective field.';
                }



                field("Campus Code"; Rec."Campus Code")
                {
                    caption = 'Global Dim1';
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Global Dim1 field.';
                }
                field(Region; Rec.Region)
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field(Country; Rec.Country)
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(Stakeholder; Rec.Stakeholder)
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Stakeholder field.';
                }

                field("Payment Methods"; Rec."Payment Methods")
                {
                    caption = 'QA Area';
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the QA Area field.';
                }
                field("Amount Awarded"; Rec."Amount Awarded")
                {
                    Caption = 'Requestted Amount';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requestted Amount field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    // Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }



            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134755),
                              "No." = FIELD("No.");
            }
            systempart(Control9; Notes) { }
            systempart(Control11; MyNotes) { }
        }
    }

    actions
    {
        area(navigation)
        {
            Group(Objectives)
            {
                action("Obj")
                {
                    Caption = 'QA Objective';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    RunObject = page "Research Objectives";
                    RunPageLink = No = field("No.");
                    ToolTip = 'Executes the QA Objective action.';
                }
            }
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
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Grant WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    RunObject = Page "Grant G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Res. &Gr. Allocated per Job action.';
                }
                action("Compliance List")
                {
                    Caption = 'Compliance List';
                    ApplicationArea = basic;
                    RunObject = Page "Compliance main List";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ToolTip = 'Executes the Compliance List action.';
                }
            }
            group("&Grant")
            {
                Caption = '&Grant';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = basic;
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
                        Rec.TESTFIELD("Bill-to Partner No.");

                        JTLines.SetJobNo(Rec."No.");
                        JTLines.RUN;
                    end;
                }
                action("Grant &Planning Lines")
                {
                    Caption = 'Grant &Planning Lines';
                    RunObject = Page "Grant Planning List";
                    RunPageLink = "Grant No." = FIELD("No.");
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Statistics action.';
                }
                separator(Separator64) { }
                action(Partners)
                {
                    Caption = 'Partners';
                    RunObject = Page "Project Partners";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Partners action.';
                }
                action(Donors)
                {
                    Caption = 'Donors';
                    RunObject = Page "Project Donors";
                    RunPageLink = "Grant No" = FIELD("No.");
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Donors action.';
                }
                separator(Separator1102755035) { }
                action("Personnel Cost Alloc.")
                {
                    Caption = 'Personnel Cost Alloc.';
                    RunObject = Page "Project Personnel Cost Alloc";
                    RunPageLink = Project = FIELD("No.");
                    ApplicationArea = basic;
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
                        //Release the grant for Approval
                        //TESTFIELD("Total Cost");
                        varVar := rec;
                        // IF "Response To fund Opportunity" = TRUE THEN
                        //   IF NOT RecordLinkCheck(Rec) THEN ERROR('You have to attach a link to this document');

                        ApprovalMgt.OnSendDocForApproval(varVar);
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
                        VaraVar: Variant;
                    begin
                        VaraVar := rec;
                        ApprovalMgt.OnCancelDocApprovalRequest(VaraVar);
                    end;
                }
                separator(Separator1102755020) { }


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
        Rec.Status := Rec.Status::QA;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;

        //IF NOT MapMgt.TestSetup THEN
        // CurrForm.MapPoint.VISIBLE(FALSE);

        CurrencyCheck;
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;

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

