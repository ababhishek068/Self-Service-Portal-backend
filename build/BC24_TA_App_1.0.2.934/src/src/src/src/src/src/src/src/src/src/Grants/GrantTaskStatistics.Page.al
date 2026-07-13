Page 50064 "Grant Task Statistics"
{
    Caption = 'Grant Task Statistics';
    DataCaptionExpression = Rec.Caption;
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Job-Task";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                label(Control11)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19057252;
                }
                label(Control55)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19012801;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(Text000; Text000)
                {
                    ApplicationArea = Basic;
                    Caption = 'Price LCY';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Price LCY field.';
                }
                label(Control10)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19068736;
                    Style = Strong;
                    StyleExpr = true;
                }
                label(Control15)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19011378;
                }
                field(Control169; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Schedule; PL[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        ////JobCalcStatistics.ShowPlanningLine(3,1,TRUE);
                    end;
                }
                field(SchedulePriceLCYItem; PL[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //
                        //JobCalcStatistics.ShowPlanningLine(3,2,TRUE);
                    end;
                }
                field(Usage; PL[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,TRUE);
                    end;
                }
                field(UsagePriceLCYItem; PL[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,TRUE);
                    end;
                }
                field(Contract; PL[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,1,FALSE);
                    end;
                }
                field(ContractPriceLCYItem; PL[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,2,FALSE);
                    end;
                }
                field(Invoiced; PL[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,FALSE);
                    end;
                }
                field(InvoicedPriceLCYItem; PL[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,FALSE);
                    end;
                }
                field(CostLCY; Text000)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost LCY';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Cost LCY field.';
                }
                field(Control129; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(CL1; CL[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,1,TRUE);
                    end;
                }
                field(ScheduleCostLCYItem; CL[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,2,TRUE);
                    end;
                }
                field(CL5; CL[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,1,TRUE);
                    end;
                }
                field(UsageCostLCYItem; CL[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,2,TRUE);
                    end;
                }
                field(CL9; CL[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,1,FALSE);
                    end;
                }
                field(ContractCostLCYItem; CL[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,2,FALSE);
                    end;
                }
                field(CL13; CL[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,1,FALSE);
                    end;
                }
                label(Control17)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19073853;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(InvoicedCostLCYItem; CL[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,2,FALSE);
                    end;
                }
                field(ProfitLCY; Text000)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit LCY';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Profit LCY field.';
                }
                field(Control155; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(PL1CL1; PL[1] - CL[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,1,TRUE);
                    end;
                }
                field(ScheduleProfitLCYItem; PL[2] - CL[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,2,TRUE);
                    end;
                }
                field(PL5CL5; PL[5] - CL[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,TRUE);
                    end;
                }
                field(PL9CL9; PL[9] - CL[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,1,FALSE);
                    end;
                }
                field(PL13CL13; PL[13] - CL[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,FALSE);
                    end;
                }
                label(Control20)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19080003;
                }
                field(Control170; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(UsageProfitLCYItem; PL[6] - CL[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,TRUE);
                    end;
                }
                field(ContractProfitLCYItem; PL[10] - CL[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,2,FALSE);
                    end;
                }
                field(InvoicedProfitLCYItem; PL[14] - CL[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit LCY (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit LCY (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,FALSE);
                    end;
                }
                label(Control25)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19080004;
                }
                field(Control171; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(SchedulePriceLCYGLAcc; PL[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,3,TRUE);
                    end;
                }
                field(SchedulePriceLCYTotal; PL[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,0,TRUE);
                    end;
                }
                field(UsagePriceLCYGLAcc; PL[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,TRUE);
                    end;
                }
                field(UsagePriceLCYTotal; PL[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,0,TRUE);
                    end;
                }
                field(ContractPriceLCYGLAcc; PL[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,3,FALSE);
                    end;
                }
                field(ContractPriceLCYTotal; PL[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,0,FALSE);
                    end;
                }
                field(InvoicedPriceLCYGLAcc; PL[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,FALSE);
                    end;
                }
                field(InvoicedPriceLCYTotal; PL[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,0,FALSE);
                    end;
                }
                field(Control145; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control151; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(ScheduleCostLCYGLAcc; CL[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,3,TRUE);
                    end;
                }
                field(ScheduleCostLCYTotal; CL[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,0,TRUE);
                    end;
                }
                field(UsageCostLCYGLAcc; CL[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,3,TRUE);
                    end;
                }
                field(UsageCostLCYTotal; CL[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,0,TRUE);
                    end;
                }
                field(ContractCostLCYGLAcc; CL[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,3,FALSE);
                    end;
                }
                field(ContractCostLCYTotal; CL[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(1,0,FALSE);
                    end;
                }
                field(InvoicedCostLCYGLAcc; CL[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,3,FALSE);
                    end;
                }
                field(InvoicedCostLCYTotal; CL[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(1,0,FALSE);
                    end;
                }
                field(Control156; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control158; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(ScheduleProfitLCYGLAcc; PL[3] - CL[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,3,TRUE);
                    end;
                }
                field(ScheduleProfitLCYTotal; PL[4] - CL[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,0,TRUE);
                    end;
                }
                field(UsageProfitLCYGLAcc; CL[7] - CL[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,TRUE);
                    end;
                }
                field(UsageProfitLCYTotal; PL[8] - CL[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,0,TRUE);
                    end;
                }
                field(ContractProfitLCYGLAcc; PL[11] - CL[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,3,FALSE);
                    end;
                }
                field(ContractProfitLCYTotal; PL[12] - CL[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(3,0,FALSE);
                    end;
                }
                field(InvoicedProfitLCYGLAcc; PL[15] - CL[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit LCY (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit LCY (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,FALSE);
                    end;
                }
                field(InvoicedProfitLCYTotal; PL[16] - CL[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit LCY (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit LCY (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,0,FALSE);
                    end;
                }
            }
            group(Currency)
            {
                Caption = 'Currency';
                label(Control117)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19080001;
                }
                label(Control143)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19059736;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(Price; Text000)
                {
                    ApplicationArea = Basic;
                    Caption = 'Price';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                label(Control80)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19077570;
                    Style = Strong;
                    StyleExpr = true;
                }
                label(Control102)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19080002;
                }
                field(Control173; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(P1; P[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,1,TRUE);
                    end;
                }
                field(SchedulePriceItem; P[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,2,TRUE);
                    end;
                }
                field(P5; P[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,1,TRUE);
                    end;
                }
                field(UsagePriceItem; P[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,2,TRUE);
                    end;
                }
                field(P9; P[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,1,FALSE);
                    end;
                }
                field(ContractPriceItem; P[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,2,FALSE);
                    end;
                }
                field(P13; P[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,1,FALSE);
                    end;
                }
                field(InvoicedPriceItem; P[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,2,FALSE);
                    end;
                }
                field(Control159; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control160; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(C1; C[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,1,TRUE);
                    end;
                }
                field(ScheduleCostItem; C[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,2,TRUE);
                    end;
                }
                field(C5; C[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,1,TRUE);
                    end;
                }
                field(UsageCostItem; C[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,2,TRUE);
                    end;
                }
                field(C9; C[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,1,FALSE);
                    end;
                }
                field(ContractCostItem; C[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,2,FALSE);
                    end;
                }
                field(C13; C[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,1,FALSE);
                    end;
                }
                label(Control85)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19075586;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(InvoicedCostItem; C[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,2,FALSE);
                    end;
                }
                field(Control164; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control165; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(P1C1; P[1] - C[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,1,TRUE);
                    end;
                }
                field(ScheduleProfitItem; P[2] - C[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,2,TRUE);
                    end;
                }
                field(P5C5; P[5] - C[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,TRUE);
                    end;
                }
                field(P9C9; P[9] - C[9])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,1,FALSE);
                    end;
                }
                field(P13C13; P[13] - C[13])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,1,FALSE);
                    end;
                }
                label(Control89)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19055809;
                }
                field(Control174; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(UsageProfitItem; P[6] - C[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,TRUE);
                    end;
                }
                field(ContractProfitItem; P[10] - C[10])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,2,FALSE);
                    end;
                }
                field(InvoicedProfitItem; P[14] - C[14])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit (Item)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit (Item) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,2,FALSE);
                    end;
                }
                label(Control75)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19028226;
                }
                field(Control175; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(SchedulePriceGLAcc; P[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,3,TRUE);
                    end;
                }
                field(SchedulePriceTotal; P[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Price (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Price (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,0,TRUE);
                    end;
                }
                field(UsagePriceGLAcc; P[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,3,TRUE);
                    end;
                }
                field(UsagePriceTotal; P[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Price (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Price (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,0,TRUE);
                    end;
                }
                field(ContractPriceGLAcc; P[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,3,FALSE);
                    end;
                }
                field(ContractPriceTotal; P[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Price (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Price (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,0,FALSE);
                    end;
                }
                field(InvoicedPriceGLAcc; P[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,3,FALSE);
                    end;
                }
                field(InvoicedPriceTotal; P[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Price (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Price (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(4,0,FALSE);
                    end;
                }
                field(Control161; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control163; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(ScheduleCostGLAcc; C[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,3,TRUE);
                    end;
                }
                field(ScheduleCostTotal; C[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Cost (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Cost (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,0,TRUE);
                    end;
                }
                field(UsageCostGLAcc; C[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,3,TRUE);
                    end;
                }
                field(UsageCostTotal; C[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Cost (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Cost (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,0,TRUE);
                    end;
                }
                field(ContractCostGLAcc; C[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,3,FALSE);
                    end;
                }
                field(ContractCostTotal; C[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Cost (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Cost (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(2,0,FALSE);
                    end;
                }
                field(InvoicedCostGLAcc; C[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,3,FALSE);
                    end;
                }
                field(InvoicedCostTotal; C[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Cost (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(2,0,FALSE);
                    end;
                }
                field(Control166; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(Control167; Text000)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Text000 field.';
                }
                field(ScheduleProfitGLAcc; P[3] - C[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,3,TRUE);
                    end;
                }
                field(ScheduleProfitTotal; P[4] - C[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Profit (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Schedule Profit (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,0,TRUE);
                    end;
                }
                field(UsageProfitGLAcc; C[7] - C[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,TRUE);
                    end;
                }
                field(UsageProfitTotal; P[8] - C[8])
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage Profit (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage Profit (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,0,TRUE);
                    end;
                }
                field(ContractProfitGLAcc; P[11] - C[11])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,3,FALSE);
                    end;
                }
                field(ContractProfitTotal; P[12] - C[12])
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Profit (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Profit (Total) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowPlanningLine(4,0,FALSE);
                    end;
                }
                field(InvoicedProfitGLAcc; P[15] - C[15])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit (G/L Acc.)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit (G/L Acc.) field.';

                    trigger OnDrillDown()
                    begin
                        //JobCalcStatistics.ShowLedgEntry(3,3,FALSE);
                    end;
                }
                field(InvoicedProfitTotal; P[16] - C[16])
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Profit (Total)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoiced Profit (Total) field.';

                    trigger OnDrillDown()
                    begin
                        ////JobCalcStatistics.ShowLedgEntry(3,0,FALSE);
                    end;
                }
            }
        }
    }

    actions { }





    var
        CL: array[16] of Decimal;
        PL: array[16] of Decimal;
        P: array[16] of Decimal;
        C: array[16] of Decimal;
        Description2: Text[50];
        JTNo: Code[20];
        Text000: label 'Placeholder';
        Text19057252: label 'Resource';
        Text19080001: label 'Resource';
        Text19059736: label 'Price';
        Text19012801: label 'Price LCY';
        Text19077570: label 'Cost';
        Text19068736: label 'Cost LCY';
        Text19011378: label 'Item';
        Text19080002: label 'Item';
        Text19073853: label 'Profit LCY';
        Text19075586: label 'Profit';
        Text19055809: label 'G/L Account';
        Text19080003: label 'G/L Account';
        Text19028226: label 'Total';
        Text19080004: label 'Total';

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        JTNo := Rec."Grant Task No.";
        Description2 := Rec.Description;/*
        //CLEAR(//JobCalcStatistics);
        //JobCalcStatistics.JTCalculateCommonFilters(Rec,Job,FALSE);
        //JobCalcStatistics.CalculateAmounts;
        //JobCalcStatistics.RunCheck(CL);
        //JobCalcStatistics.GetLCYPriceAmounts(PL);
        //JobCalcStatistics.GetCostAmounts(C);
        //JobCalcStatistics.GetPriceAmounts(P);
        */

    end;
}

