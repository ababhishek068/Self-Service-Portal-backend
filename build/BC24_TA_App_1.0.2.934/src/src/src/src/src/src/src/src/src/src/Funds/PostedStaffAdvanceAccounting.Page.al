page 50932 "PostedStaff Advance Accounting"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Staff Advance Surrender Header";
    SourceTableView = WHERE(Posted = FILTER(true),
                            Status = FILTER(<> Cancelled));
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    Editable = "Surrender DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = "Account No.Editable";
                    ToolTip = 'Specifies the value of the Account No. field.';

                    trigger OnValidate()
                    begin
                        AccountName := GetCustName(Rec."Account No.");
                    end;
                }
                field(AccountName; AccountName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    Editable = "Imprest Issue Doc. NoEditable";
                    ToolTip = 'Specifies the value of the Advance Issue Doc. No field.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Caption = 'Advance Issue Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Advance Issue Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; DimName1)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnValidate()
                    begin
                        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field(DimName2; DimName2)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = "Responsibility CenterEditable";
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Surrender Posting Date"; Rec."Surrender Posting Date")
                {
                    Editable = "Surrender Posting DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Posting Date field.';
                }
                field("Allow Overexpenditure"; Rec."Allow Overexpenditure")
                {
                    ToolTip = 'Specifies the value of the Allow Overexpenditure field.';
                }
                field("Open for Overexpenditure by"; Rec."Open for Overexpenditure by")
                {
                    ToolTip = 'Specifies the value of the Open for Overexpenditure by field.';
                }
                field("Date opened for OvExpenditure"; Rec."Date opened for OvExpenditure")
                {
                    ToolTip = 'Specifies the value of the Date opened for OvExpenditure field.';
                }
            }
            part(ImprestLines; "Staff Advanc Surrender Details")
            {
                Editable = ImprestLinesEditable;
                SubPageLink = "Surrender Doc No." = FIELD(No);
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
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(70134731, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Surrender Posting DateEditable" := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Surrender DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravAccHeader.Reset;
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::Pending);

        if TravAccHeader.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************END ****************************************//

        Rec."User ID" := UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        //SETFILTER(Status,'<>Cancelled');

        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        AccountName := GetCustName(Rec."Account No.");
    end;

    var
        DimName1: Text[60];
        DimName2: Text[60];
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record "Staff Advance Header";
        UserMgt: Codeunit "User Setup Management BR";
        AccountName: Text[100];
        TravAccHeader: Record "Staff Advance Surrender Header";
        Payline: Record "Staff Advanc Surrender Details";
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
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
            "Imprest Issue Doc. NoEditable" := false;
            "Responsibility CenterEditable" := false;
            "Surrender Posting DateEditable" := true;
            ImprestLinesEditable := false;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            "Imprest Issue Doc. NoEditable" := true;
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
        Rec.Posted := true;
        Rec.Status := Rec.Status::Posted;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Modify;
        //Tag the Source Imprest Requisition as Surrendered
        ImprestReq.Reset;
        ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
        if ImprestReq.Find('-') then begin
            ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
            ImprestReq.Modify;
        end;
        //End Tag
        //Post Committment Reversals
        Doc_Type := Doc_Type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //Update Controls as necessary
        //SETFILTER(Status,'<>Cancelled');
        UpdateControl;
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
        AccountName := GetCustName(Rec."Account No.");
    end;
}

