Page 50928 "HR Leave Ledger"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Leave Ledger";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(NoofDays; Rec."No. of Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. of Days field.';
                }
                field(TransactionDescription; Rec."Transaction Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Description field.';
                }
                field(LeavePeriod; Rec."Leave Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Period field.';
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ReverseLeaveEntry)
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Leave Entry';
                Image = ReverseLines;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Reverse Leave Entry action.';

                trigger OnAction()
                begin
                    if Rec."Entry Type" = Rec."entry type"::Allocation then Error('The selected entry has already been involved in a reversal.\Please select another entry to reverse...');
                    if Confirm('This will reverse the selected Ledger entry, continue?', false) = false then exit;
                    leaveLedger.Reset;
                    if leaveLedger.Find('+') then
                        lastNo := leaveLedger."Entry No." + 10
                    else
                        lastNo := 10;

                    Rec."Entry Type" := Rec."entry type"::Allocation;
                    Rec."Reversed By" := UserId;
                    Rec.Modify;

                    leaveLedger.Init;
                    leaveLedger."Entry No." := lastNo;
                    leaveLedger."Employee No" := Rec."Employee No";
                    leaveLedger."Document No" := Rec."Document No";
                    leaveLedger."Leave Type" := Rec."Leave Type";
                    leaveLedger."Transaction Date" := Rec."Transaction Date";
                    leaveLedger."Transaction Type" := Rec."Transaction Type";
                    leaveLedger."No. of Days" := ((Rec."No. of Days") * (-1));
                    leaveLedger."Transaction Description" := Rec."Transaction Description";
                    leaveLedger."Leave Period" := Rec."Leave Period";
                    leaveLedger."Entry Type" := leaveLedger."entry type"::Allocation;
                    leaveLedger."Reversed By" := UserId;
                    leaveLedger.Insert;
                end;
            }
        }
    }

    var
        leaveLedger: Record "HR Leave Ledger";
        lastNo: Integer;
}

