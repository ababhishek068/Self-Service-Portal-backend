Page 50454 "Posted Grant Surrender"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Grant Surrender Header";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(SurrenderDate; Rec."Surrender Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Surrender DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field(Grant; Rec.Grant)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Account No.Editable";
                    ToolTip = 'Specifies the value of the Account No. field.';

                    trigger OnValidate()
                    begin
                        AccountName := GetCustName(Rec."Account No.");
                    end;
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(GrantPhase; Rec."Grant Phase")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant Phase field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        job.Get(Rec.Grant);
                        GrantPhases.Reset;
                        GrantPhases.SetFilter(GrantPhases.Code, '<=%1', job."Grant Phases");
                        if Page.RunModal(39004402, GrantPhases, Rec.No) = Action::LookupOK
                        then begin
                            Rec."Grant Phase" := GrantPhases.Code;
                            Rec.Validate("Grant Phase");
                        end;
                    end;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; DimName1)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DimName1 field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnValidate()
                    begin
                        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field(DimName2; DimName2)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DimName2 field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = "Responsibility CenterEditable";
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(SurrenderPostingDate; Rec."Surrender Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Surrender Posting DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Posting Date field.';
                }
                field(AllowOverexpenditure; Rec."Allow Overexpenditure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Overexpenditure field.';
                }
                field(OpenforOverexpenditureby; Rec."Open for Overexpenditure by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open for Overexpenditure by field.';
                }
                field(DateopenedforOvExpenditure; Rec."Date opened for OvExpenditure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date opened for OvExpenditure field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field(DisbursedCost; Rec."Disbursed Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disbursed Cost field.';
                }
                field(ActualSpent; Rec."Actual Spent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Spent field.';
                }
                field(QuestionedCost; Rec."Questioned Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Questioned Cost field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Approve action.';

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Pending then
                        Error('The document has already been processed.');

                    if Rec.Amount < 0 then
                        Error('Amount cannot be less than zero.');

                    if Rec.Amount = 0 then
                        Error('Please enter amount.');

                    if Confirm('Are you sure you would like to approve the payment?', false) = true then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify;
                        Message('Document approved successfully.');
                    end;
                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                Visible = false;
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        /*DocumentType:=DocumentType::Requisition;
                        ApprovalEntries.SetRecordFilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                        ApprovalEntries.RUN;
                        */
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    Report.Run(39004318, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Surrender Posting DateEditable" := true;
        "Responsibility CenterEditable" := true;
        "Surrender DateEditable" := true;
    end;

    var
        DimName1: Text[60];
        DimName2: Text[60];
        AccountName: Text[100];
        Payline: Record "Grant Surrender Details";
        GrantPhases: Record "Grant Phases";
        job: Record Jobs;
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Surrender Posting DateEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;

    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name := '';

        GLSetup.Reset;
        GLSetup.Get();

        DimVal.Reset;
        DimVal.SetRange(DimVal.Code, Code);

        if DimNo = 1 then begin
            DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 1 Code");
        end
        else
            if DimNo = 2 then begin
                DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 2 Code");
            end;
        if DimVal.Find('-') then begin
            Name := DimVal.Name;
        end;

    end;

    procedure UpdateControl()
    begin
        if Rec.Status <> Rec.Status::Pending then begin
            "Surrender DateEditable" := false;
            "Account No.Editable" := false;
            //   CurrForm."Payment Voucher Doc. No".EDITABLE:=FALSE;
            "Responsibility CenterEditable" := false;
            "Surrender Posting DateEditable" := true;
            ImprestLinesEditable := false;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            //   CurrForm."Payment Voucher Doc. No".EDITABLE:=TRUE;
            "Responsibility CenterEditable" := true;
            "Surrender Posting DateEditable" := false;
            ImprestLinesEditable := true;

        end;
    end;

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name := '';
        if Cust.Get(No) then
            Name := Cust.Name;
        exit(Name);
    end;

    procedure UpdateforNoActualSpent()
    begin
        /*
          Posted:=TRUE;
          Status:=Status::Posted;
          "Date Posted":=TODAY;
          "Time Posted":=TIME;
          "Posted By":=USERID;
          MODIFY;
        //Tag the Source Imprest Requisition as Surrendered
           ImprestReq.RESET;
           ImprestReq.SETRANGE(ImprestReq."No.","Payment Voucher Doc. No");
           IF ImprestReq.FIND('-') THEN BEGIN
             ImprestReq."Surrender Status":=ImprestReq."Surrender Status"::Full;
             ImprestReq.MODIFY;
           END;
        //End Tag
        //Post Committment Reversals
        Doc_Type:=Doc_Type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type,"Payment Voucher Doc. No");
        */

    end;

    procedure CompareAllAmounts()
    begin
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
    begin
        if BCsetup.Get() then begin
            if not BCsetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        Exists := false;
        Payline.Reset;
        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
        Payline.SetRange(Payline.Committed, false);
        Payline.SetRange(Payline."Budgetary Control A/C", true);
        if Payline.Find('-') then
            Exists := true;
    end;
}

