page 51071 "Bank Transactions Buffer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bank Transactions Buffer";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }
                field("Transcation Date"; Rec."Transcation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transcation Date field.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Caption = 'Customer No';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer No field.';
                }
                field("Sales Person"; Rec."Sales Person")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sales Person field.';
                }
                field("External Document No"; Rec."External Document No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the External Document No field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                caption = 'Post';
                ToolTip = 'Executes the Post action.';
                trigger OnAction();
                var
                    GenReceipts: report "Generate Receipts";
                    BankBuffer: Record "Bank Transactions Buffer";
                begin
                    BankBuffer.reset;
                    if BankBuffer.find('-') then begin
                        GenReceipts.SetTableView(BankBuffer);
                        GenReceipts.Run();
                    end;
                end;
            }
        }
    }
}