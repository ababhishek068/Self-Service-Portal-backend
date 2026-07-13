page 50658 "PC Company Information"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Company Information";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    Caption = 'Website';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Website field.';
                }
                field(Vision; Rec.Vision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vision field.';
                }
                field(Mission; Rec.Mission)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mission field.';
                }
                field(Philosophy; Rec.Philosophy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Philosophy field.';
                }
                field("Core values"; Rec."Core values")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Core values field.';
                }
                field(Motto; Rec.Motto)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Motto field.';
                }

                field("Company Watermark"; Rec."Company Watermark")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Watermark field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}