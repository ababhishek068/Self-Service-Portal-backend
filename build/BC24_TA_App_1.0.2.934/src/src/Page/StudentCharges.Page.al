Page 50164 "Student Charges"
{
    PageType = List;
    SourceTable = "Student Charges";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {



                field(RegTransactonID; Rec."Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(TransactonID; Rec."Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Transacton ID field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(RecoveredFirst; Rec."Recovered First")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recovered First field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Recognized; Rec.Recognized)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Recognized field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Distribution; Rec.Distribution)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Distribution field.';
                }
                field("Charge G/L Account"; Rec."Charge G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Charge G/L Account field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }

    trigger OnDeleteRecord(): Boolean
    begin
        //IF Recognized = TRUE THEN
        //ERROR('You can not delete recognized/billed transactions.');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Transaction Type" = Rec."transaction type"::Charges then
            Rec.Validate("Transacton ID");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Recognized = true then
            ;
    end;
}

