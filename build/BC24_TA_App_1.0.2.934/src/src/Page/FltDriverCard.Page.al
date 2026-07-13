Page 50613 "Flt Driver Card"
{
    PageType = Card;
    SourceTable = "Flt Driver";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field(DriverName; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(DriverLicenseNumber; Rec."Driver License Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver License Number field.';
                }
                field(LicenseClass; Rec."License Class")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the License Class field.';
                }
                field(LastLicenseRenewal; Rec."Last License Renewal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last License Renewal field.';
                }
                field(RenewalInterval; Rec."Renewal Interval")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Renewal Interval field.';
                }
                field(RenewalIntervalValue; Rec."Renewal Interval Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Renewal Interval Value field.';
                }
                field(NextLicenseRenewal; Rec."Next License Renewal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next License Renewal field.';
                }
                field(YearOfExperience; Rec."Year Of Experience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year Of Experience field.';
                }
                field("Driver Type"; Rec."Driver Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Type field.';
                }
                field("Fuel Card No"; Rec."Fuel Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Card No field.';
                }
                field("Fuel Card Max. Value"; Rec."Fuel Card Max. Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Card Max. Value field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Vehicle Assigned"; Rec."Vehicle Assigned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Assigned field.';
                }
                field("Drivers Status"; Rec."Drivers Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drivers Status field.';
                }
            }
        }
    }

    actions { }
}

