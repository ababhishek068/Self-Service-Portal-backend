Page 50392 "Asset Repair List  Others"
{
    CardPageID = "Asset Repair Card  Others";
    Editable = false;
    PageType = List;
    SourceTable = "Asset Repair Header";
    SourceTableView = where("Asset Type" = filter("Other Assets"),
                            Status = filter(<> Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RequestNo; Rec."Request No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request No. field.';
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
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
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

