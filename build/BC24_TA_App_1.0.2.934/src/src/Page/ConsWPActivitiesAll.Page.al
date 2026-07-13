page 50950 "Cons. WP Activities(All)"
{
    Caption = 'Consolidated Workplan Activities(All)';
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Workplan Activities";
    //SourceTableView = where(Status = filter('Approved'));
    PromotedActionCategories = 'New,Process,Reports,Functions';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = "Activity Code", "Activity Description";
                ShowAsTree = false;
                field("Procurement Workplan Code"; Rec."Procurement Workplan Code")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Procurement Workplan Code field.';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Financial Year field.';
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    Caption = 'Activity Code';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Type field.';

                }
                field("Type Of Purchase"; Rec."Type Of Purchase")
                {
                    Caption = 'Product Category';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Product Category field.';
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Source of Activity Fund"; Rec."Source of Activity Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source of Activity Fund field.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    OptionCaption = '  ,PWD,Women,Youth,Open';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Procurement Method field.';
                }
                field(Totalling; Rec.Totalling)
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Totalling field.';
                }
                field("Expense Code"; Rec."Expense Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Code field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }

                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Quantity field.';
                }

                field("Approved Unit Cost"; Rec."Approved Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Unit Cost field.';
                }

                field("Approved Total Cost"; Rec."Approved Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Total Cost field.';
                }

                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount to Transfer field.';
                }

                field("Date to Transfer"; Rec."Date to Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date to Transfer field.';
                }

                field("Converted to G/L Budget"; Rec."Converted to G/L Budget")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Converted to G/L Budget field.';
                }

                field("Comments"; Rec."Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments field.';
                }

                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
                field("Board Approved"; Rec."Board Approved")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Board Approved field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Ammended; Rec.Ammended)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ammended field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Visible = true;

                action("&Print")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Cons. Finance Workplan";
                    ToolTip = 'Executes the &Print action.';

                    trigger OnAction();
                    begin

                    end;
                }

                action("BoardApproved")
                {
                    Caption = 'Mark as Board Approved';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Mark as Board Approved action.';

                    trigger OnAction();
                    var
                        ObjWorkplanActi: Record "Workplan Activities";
                    begin
                        if Confirm('You are about to Mark the Workplan for ' + Rec."Financial Year" + ' Financial Year as Board Approved. Do you want to proceed?') = true then begin
                            ObjWorkplanActi.Reset();
                            ObjWorkplanActi.SetRange("Financial Year", Rec."Financial Year");
                            if ObjWorkplanActi.Find('-') then begin
                                repeat
                                    ObjWorkplanActi."Board Approved" := true;
                                    ObjWorkplanActi.Modify();
                                until ObjWorkplanActi.Next = 0;
                                CurrPage.Update();
                                Message('Success');
                            end;
                        end else
                            error('Process Aborted');
                    end;
                }


                action(IndentWorkplan)
                {
                    Caption = '&Indent Workplan Activities';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the &Indent Workplan Activities action.';

                    trigger OnAction();
                    var
                        Text000: Label 'This function updates the indentation of all the workplan activities. ';
                        Text001: Label 'All accounts between a Begin-Total and the matching End-Total are indented one level. ';
                        Text002: Label 'The Totaling for each End-total is also updated.';
                        Text003: Label '\\Do you want to indent the workplan activities?';
                        PostingErr: Label 'Process aborted by user';
                        FundMgt_CU: Codeunit "Funds Mgt Functions";

                    begin
                        IF NOT
                                CONFIRM(
                                    Text000 +
                                    Text001 +
                                    Text002 +
                                    Text003, TRUE)
                                THEN
                            Error(PostingErr);

                        FundMgt_CU.IndentWorkplanActivities();

                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    // Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                        VarVariant: Variant;

                    begin
                        VarVariant := Rec;
                        if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) then
                            ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    // Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                        VarVariant: Variant;

                    begin
                        VarVariant := Rec;

                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }

        }
    }

    trigger OnAfterGetRecord();
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;


    procedure CheckRequiredFields();
    begin

        Rec.TESTFIELD("Account Type");
        Rec.TESTFIELD("Activity Description");
        Rec.TESTFIELD("Procurement Workplan Code");
        Rec.TESTFIELD("Date to Transfer", 0D);
    end;

    procedure LockFieldsOnBeginEndTotal(AccType: Integer): Boolean
    var
    begin
        //1 = Posting,2= Begin-Total,3 = End-Total
        //if AccType in [2, 3] then exit(false) else exit(true);
    end;

}

