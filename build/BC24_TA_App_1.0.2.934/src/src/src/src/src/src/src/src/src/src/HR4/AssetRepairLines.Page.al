Page 51241 "Asset Repair Lines"
{
    PageType = ListPart;
    SourceTable = "Asset Repair Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AssetType; Rec."Asset Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Type field.';
                }
                field(RegistartionNo; Rec."Asset No")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(AssetNo; Rec."Asset No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field(ServiceProvider; Rec."Service Provider")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Provider field.';
                }
                field(ServiceProviderName; Rec."Service Provider Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Provider Name field.';
                }
                field(TypeofMaitenance; Rec."Type of Maitenance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Maitenance field.';
                }
                field(MaitenanceDescription; Rec."Maitenance Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maitenance Description field.';
                }
                field("Service Date"; Rec."Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Date field.';
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Service Date field.';
                }
                field("Problem Classification"; Rec."Problem Classification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Problem Classification field.';
                }
                field("Problem Description"; Rec."Problem Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Problem Description field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        // area(processing)
        // {
        //     action("Officer Recommendation")
        //     {
        //         ApplicationArea = Basic;
        //         Image = Comment;
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         RunObject = Page "Repair Recommendation Card";
        //         RunPageLink = "Repair No"=field("Request No."),
        //                       "Vehicle No"=field("Registartion No");

        //         trigger OnAction()
        //         begin
        //             //test Amos
        //         end;
        //     }
        // }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;
}

