page 50614 "Flt Driver List"
{
    CardPageID = "Flt Driver Card";
    PageType = List;
    SourceTable = "Flt Driver";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field("Driver License Number"; Rec."Driver License Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver License Number field.';
                }
                field("Last License Renewal"; Rec."Last License Renewal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last License Renewal field.';
                }
                field("Renewal Interval"; Rec."Renewal Interval")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Renewal Interval field.';
                }
                field("Renewal Interval Value"; Rec."Renewal Interval Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Renewal Interval Value field.';
                }
                field("Next License Renewal"; Rec."Next License Renewal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next License Renewal field.';
                }
                field("Year Of Experience"; Rec."Year Of Experience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year Of Experience field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field("Fuel Card No"; Rec."Fuel Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Card No field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active field.';
                }
            }
        }
    }

    actions { }
}

