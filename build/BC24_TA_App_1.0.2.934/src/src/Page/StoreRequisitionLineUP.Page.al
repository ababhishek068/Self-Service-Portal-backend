/// <summary>
/// Page Store Requisition Line UP (ID 70135385).
/// </summary>
page 50861 "Store Requisition Line UP"
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
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                // field("Description 2"; "Description 2")
                // {
                //     ApplicationArea = all;
                // }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("Quantity Requested"; Rec."Quantity Requested")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity Requested field.';
                }
                field("Quantity To Issue"; Rec."Quantity To Issue")
                {
                    Visible=false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity To Issue field.';
                }

                field("Qty in store"; Rec."Qty in store")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty in store field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible=false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Visible=false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible=false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
            }
        }
    }

    actions { }
}

