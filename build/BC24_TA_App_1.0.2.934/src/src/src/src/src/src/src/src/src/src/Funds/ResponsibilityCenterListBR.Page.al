Page 50899 "Responsibility Center List BR"
{
    Caption = 'Responsibility Center List';
    Editable = true;
    PageType = Card;
    SourceTable = "Responsibility Center BR";
    UsageCategory = lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(RespCtr)
            {
                Caption = '&Resp. Ctr.';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Responsibility Center Card BR";
                    RunPageLink = Code = field(Code);
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(5714),
                                      "No." = field(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'Executes the Dimensions-Single action.';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        ToolTip = 'Executes the Dimensions-&Multiple action.';

                        trigger OnAction()
                        var
                            RespCenter: Record "Responsibility Center";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(RespCenter);
                            // DefaultDimMultiple.SetMultiRespCenter(RespCenter);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
            }
        }
    }
}

