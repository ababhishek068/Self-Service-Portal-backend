Page 51123 "Student Charges List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Student Charges";
    SourceTableView = where(Recognized = filter(true));
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
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';
                }
                field(TransactonID; Rec."Transacton ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transacton ID field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(AmountPaid; Rec."Amount Paid")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount Paid field.';
                }
                field(RecoveryPriority; Rec."Recovery Priority")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recovery Priority field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reverse)
            {
                Caption = 'Post Charge Reversal';
                ApplicationArea = basic;
                image = ReverseLines;
                ToolTip = 'Executes the Post Charge Reversal action.';
                trigger OnAction()
                var
                    UserRec: Record "User Setup";
                    Billing: codeunit "Student Billing";
                begin
                    Rec.TestField(Recognized, true);
                    if Confirm('Do you really want to reverse the selected transaction?', false) then begin
                        UserRec.get(Database.UserId);
                        userrec.TestField("Allow Transaction Reversal", true);
                        Billing.PostForcedReversal(Rec."Transacton ID");
                        Rec.Reversed := true;
                        Rec.modify;
                        message('Reversal Posted Succefully');
                    end;
                end;
            }
        }
    }
}

