Page 50577 "Other Maintenance Request List"
{
    Editable = false;
    PageType = List;
    CardPageId = "Other Maintenance Request Card";
    SourceTable = "FLT-Fuel & Maintenance Req.";
    SourceTableView = where(Status = const(Open),
                         "Maintenance Type" = filter(Other),
                            Type = filter(Maintenance));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(RequestDate; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(VendorName; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(FixedAssetNo; Rec."Fixed Asset No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fixed Asset No field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control5; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdateMotorVehiclesFA)
            {
                ApplicationArea = Basic;
                Caption = 'Update Motor Vehicles FA';
                ToolTip = 'Executes the Update Motor Vehicles FA action.';

                trigger OnAction()
                begin
                    //Vehicles
                    FixedAsset.Reset;
                    FixedAsset.SetFilter(FixedAsset."FA Subclass Code", '%1', '');
                    // if FixedAsset.Find('-') then FixedAsset.ModifyAll(FixedAsset."Asset Type",FixedAsset."asset type"::"4");

                    //Machines

                    //Office Equipement
                    FixedAsset.Reset;
                    FixedAsset.SetFilter(FixedAsset."FA Subclass Code", '%1|%2|%3', 'FURN_FITT', 'COMP_EQUIP', 'OFF_EQUIP');
                    //  if FixedAsset.Find('-') then FixedAsset.ModifyAll(FixedAsset."Asset Type",FixedAsset."asset type"::"Other Assets");

                    Message('Done');
                end;
            }
        }
    }

    var
        FixedAsset: Record "Fixed Asset";
}

