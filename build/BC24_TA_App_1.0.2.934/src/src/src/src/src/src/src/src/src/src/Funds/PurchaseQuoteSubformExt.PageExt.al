pageextension 50020 "Purchase Quote Subform Ext" extends "Purchase Quote Subform"
{
    layout
    {
        addafter(Description)
        {
            // field("Description 2"; "Description 2")
            // {
            //     ApplicationArea = basic;

            // }
            field("Unit of Measure."; Rec."Unit of Measure")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';

            }
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item G/L Budget Account field.';
            }
            field("Expense Code"; Rec."Expense Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expense Code field.';
            }
            field("Procurement Plan Item No"; Rec."Procurement Plan Item No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Procurement Plan Item No field.';
            }
            field("WorkPlan No."; Rec."WorkPlan No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the WorkPlan No. field.';
            }
            // field("Expected Receipt Date"; "Expected Receipt Date")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field("Qty In Proc. Plan"; Rec."Qty In Proc. Plan")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Qty In Proc. Plan field.';
            }

        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        modify("Unit of Measure")
        {
            Visible = false;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }
}