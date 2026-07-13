page 50729 "Store Req Line Approved"
{
    PageType = ListPart;
    SourceTable = "Store Requistion Lines";
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("Quantity Requested"; Rec."Quantity Requested")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity Requested field.';
                }
                field("Quantity To Issue"; Rec."Quantity To Issue")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity To Issue field.';
                }
                field("Tag No";"Tag No"){}

                field("Qty in store"; Rec."Qty in store")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty in store field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

    actions { }
}

