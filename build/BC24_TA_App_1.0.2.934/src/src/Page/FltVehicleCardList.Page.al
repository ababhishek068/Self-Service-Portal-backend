page 50618 "Flt Vehicle Card List"
{
    CardPageID = "Flt Vehicle Card";
    PageType = List;
    SourceTable = "FLT-Vehicle Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Responsible Employee"; Rec."Responsible Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsible Employee field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field(Inactive; Rec.Inactive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inactive field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Service Date field.';
                }
                field("Service Interval"; Rec."Service Interval")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Interval field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Maintenance Vendor No."; Rec."Maintenance Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maintenance Vendor No. field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field("Year Of Manufacture"; Rec."Year Of Manufacture")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year Of Manufacture field.';
                }
                field("Country Of Origin"; Rec."Country Of Origin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country Of Origin field.';
                }
                field(Ownership; Rec.Ownership)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ownership field.';
                }
                field("Body Color"; Rec."Body Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Body Color field.';
                }
                field("Interior Color"; Rec."Interior Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interior Color field.';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration No. field.';
                }
                field("Chassis Serial No."; Rec."Chassis Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Chassis Serial No. field.';
                }
                field("Engine Serial No."; Rec."Engine Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Engine Serial No. field.';
                }
                field("Ignition Key Code"; Rec."Ignition Key Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ignition Key Code field.';
                }
                field("Door Key Code"; Rec."Door Key Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Door Key Code field.';
                }
                field("Tare Weight"; Rec."Tare Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tare Weight field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Open_Travel)
            {
                Caption = 'Open Travel Requests';
                Image = ResourceSetup;
                Promoted = true;
                ApplicationArea = Basic;
                RunObject = Page "Approved Transport Req";
                RunPageLink = "Vehicle Allocated" = FIELD("Registration No.");
                ToolTip = 'Executes the Open Travel Requests action.';
            }
            action(Open_Maint)
            {
                Caption = 'Open Maintenance/Fuel Requests';
                Image = History;
                Promoted = true;
                ApplicationArea = Basic;
                RunObject = Page "Fuel and Maintenance List";
                RunPageLink = "Vehicle Reg No" = FIELD("Registration No.");
                ToolTip = 'Executes the Open Maintenance/Fuel Requests action.';
            }
        }
    }
}

