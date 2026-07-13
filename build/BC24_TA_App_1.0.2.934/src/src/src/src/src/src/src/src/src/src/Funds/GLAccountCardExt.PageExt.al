pageextension 50013 "G/L Account Card Ext" extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Direct Posting")
        {
            field("Budget Controlled"; Rec."Budget Controlled")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Budget Controlled field.';
            }
            field("Expense Code"; Rec."Expense Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Expense Code field.';
            }


        }
        addafter(Balance)
        {
            field("Committment Amount"; Rec."Committment Amount")
            {
                ApplicationArea = basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Committment Amount field.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create G\L Account");

    end;
    trigger OnModifyRecord(): Boolean
    begin
        

    end;

}