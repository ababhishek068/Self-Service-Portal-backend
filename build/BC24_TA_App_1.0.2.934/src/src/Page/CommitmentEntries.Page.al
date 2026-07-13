Page 50748 "Commitment Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = Committment;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(MonthBudget; Rec."Month Budget")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Month Budget field.';
                }
                field(MonthActual; Rec."Month Actual")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Month Actual field.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
                field(CommittedBy; Rec."Committed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed By field.';
                }
                field(CommittedDate; Rec."Committed Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed Date field.';
                }
                field(CommittedTime; Rec."Committed Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed Time field.';
                }
                field(CommittedMachine; Rec."Committed Machine")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed Machine field.';
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled field.';
                }
                field(CancelledBy; Rec."Cancelled By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled By field.';
                }
                field(CancelledDate; Rec."Cancelled Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled Date field.';
                }
                field(CancelledTime; Rec."Cancelled Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled Time field.';
                }
                field(CancelledMachine; Rec."Cancelled Machine")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled Machine field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(GLAccountNo; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget field.';
                }
                field(VendorCustNo; Rec."Vendor/Cust No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor/Cust No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(EXistGL; Rec."EXist GL")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the EXist GL field.';
                }
                field(ExistPostedInv; Rec."Exist Posted Inv")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exist Posted Inv field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(UploadedManually; Rec."Uploaded Manually")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Uploaded Manually field.';
                }
                field(BudgetCheckCriteria; Rec."Budget Check Criteria")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Check Criteria field.';
                }
                field(ActualSource; Rec."Actual Source")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Source field.';
                }
                field(DocumentLineNo; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Mark as Cancelled")
            {
                ApplicationArea = Basic;
                Image = Cancel;
                ToolTip = 'Executes the Mark as Cancelled action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to cancel the Commitment?', false) then begin
                        if UserRec.Get(Database.UserId) then begin
                            if UserRec."Can Edit Budget" = false then Error('Please note that you dont have the rights to cancel committment!');
                            Rec.Cancelled := true;
                            Rec."Cancelled By" := UserId;
                            Rec."Cancelled Date" := Today;
                            Rec."Cancelled Time" := Time;
                            Rec.Modify;
                        end else begin
                            Error('Please note that you dont have the rights to cancel committment!');
                        end;
                    end;
                end;
            }
        }
    }

    var
        UserRec: Record "User Setup";
}

