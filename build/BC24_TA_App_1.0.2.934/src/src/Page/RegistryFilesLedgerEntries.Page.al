Page 50780 "Registry Files Ledger Entries"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Registry Files Ledger Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(FileNoFolioNo; Rec."File No./Folio No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File No./Folio No. field.';
                }
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field(SourceDepartment; Rec."Source Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Department field.';
                }
                field(DestinationDepartment; Rec."Destination Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Department field.';
                }
                field(DispatchOfficerCode; Rec."Dispatch Officer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dispatch Officer Code field.';
                }
                field(ReceivingOfficerCode; Rec."Receiving Officer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Officer Code field.';
                }
                field(ExpectedReturnDate; Rec."Expected Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Return Date field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions { }
}

