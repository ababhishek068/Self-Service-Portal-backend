/// <summary>
/// Additive fields for the Maintenance UAT gaps (rows R39, R40, R41, R42):
/// technician assignment, requestor receipt confirmation of the maintained FA,
/// and odometer capture so the 5,000 km service rule and "next maintenance KM"
/// can be shown. Base table 50865 is not modified — only extended.
/// </summary>
tableextension 52124 "Portal Fuel Maint. Ext." extends "FLT-Fuel & Maintenance Req."
{
    fields
    {
        field(52124; "Assigned Technician"; Code[20])
        {
            Caption = 'Assigned Technician';
            TableRelation = "HR-Employee"."No.";
            DataClassification = CustomerContent;
        }
        field(52125; "Assigned Technician Name"; Text[100])
        {
            Caption = 'Assigned Technician Name';
            DataClassification = CustomerContent;
        }
        field(52126; "Current Odometer"; Decimal)
        {
            Caption = 'Current Odometer (KM)';
            DecimalPlaces = 0 : 0;
            DataClassification = CustomerContent;
        }
        field(52127; "Last Service Odometer"; Decimal)
        {
            Caption = 'Last Service Odometer (KM)';
            DecimalPlaces = 0 : 0;
            DataClassification = CustomerContent;
        }
        field(52128; "Next Service KM"; Decimal)
        {
            Caption = 'Next Service KM';
            DecimalPlaces = 0 : 0;
            DataClassification = CustomerContent;
        }
        field(52129; "FA Received By"; Code[50])
        {
            Caption = 'FA Received By';
            DataClassification = CustomerContent;
        }
        field(52130; "FA Received Date"; Date)
        {
            Caption = 'FA Received Date';
            DataClassification = CustomerContent;
        }
        field(52131; "FA Receipt Remarks"; Text[100])
        {
            Caption = 'FA Receipt Remarks';
            DataClassification = CustomerContent;
        }
    }
}
