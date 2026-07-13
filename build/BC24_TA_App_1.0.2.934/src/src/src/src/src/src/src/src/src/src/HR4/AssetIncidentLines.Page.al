Page 50377 "Asset Incident Lines"
{
    PageType = ListPart;
    SourceTable = "Asset Incident Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(FixedAssetNo; Rec."Fixed Asset No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Fixed Asset No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(IncidentDate; Rec."Incident Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Date field.';
                }
                field(IncidentDescription; Rec."Incident Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Description field.';
                }
            }
        }
    }

    actions { }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;
}

