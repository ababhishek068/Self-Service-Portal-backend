Page 50829 "HMS Laboratory Item Subform"
{
    PageType = ListPart;
    SourceTable = "HMS Laboratory Item Usage";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(No; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec."Item Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Unitofmeasure; Rec."Item Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit of measure';
                    ToolTip = 'Specifies the value of the Unit of measure field.';
                }
                field(Quantity; Rec."Item Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
    }

    actions { }
}

