Page 50805 "Disposal Plan Table Line"
{
    PageType = ListPart;
    SourceTable = "Disposal plan table lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RefNo; Rec."Ref. No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ref. No. field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(SubRefNo; Rec."Sub. Ref. No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sub. Ref. No. field.';
                }
                field(Itemdescription; Rec."Item description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item description field.';
                }
                field(Justification; Rec.Justification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Justification field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(UnitofIssue; Rec."Unit of Issue")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit of Issue field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(PlannedDate; Rec."Planned Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Planned Date field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';

                }
                field("Asset Location"; Rec."Asset Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Location field.';

                }
                field("Disposal Method"; Rec."Disposal Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Method field.';

                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Region field.';

                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(ItemTagNo; Rec."Item/Tag No")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Item/Tag No field.';
                }
                field(SerialNo; Rec."Serial No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }

            }
        }
    }

    actions { }
}

