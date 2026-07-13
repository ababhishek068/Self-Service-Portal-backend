Page 51152 "Disposal Plan Lines"
{
    PageType = ListPart;
    SourceTable = "Disposal Plan Lines";
    SourceTableView = WHERE(Disposed = filter('No'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Disposal  No"; Rec."Disposal  No")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disposal  No field.';
                }
                field("Fixed Location"; Rec."Fixed Location")
                {
                    Caption = 'Assets Location';
                    ToolTip = 'Specifies the value of the Assets Location field.';
                }
                field("Justification For Disposal"; Rec."Justification For Disposal")
                {
                    ToolTip = 'Specifies the value of the Justification For Disposal field.';
                }
                field("Item Life Span"; Rec."Item Life Span")
                {
                    Caption = 'Asset Life Span';
                    ToolTip = 'Specifies the value of the Asset Life Span field.';
                }
                field("Tag No."; Rec."Tag No.")
                {
                    ToolTip = 'Specifies the value of the Tag No. field.';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field("Disposal Method"; Rec."Disposal Method")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field(Disposed; Rec.Disposed)
                {
                    ToolTip = 'Specifies the value of the Disposed field.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ToolTip = 'Specifies the value of the Total Price field.';
                }
            }
        }
    }

    actions { }
}

