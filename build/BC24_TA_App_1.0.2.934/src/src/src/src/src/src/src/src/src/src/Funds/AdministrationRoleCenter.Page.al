Page 50944 "Administration RoleCenter"
{
    Caption = 'Administration Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
            }
            group(Control11)
            {
                part(Control8; "Sec-Visitor Manager (Active)")
                {
                    Caption = 'Visitors';
                    Visible = false;
                }
            }
            group(Control39)
            {
                part(Control35; "Security Role Cue")
                {
                    Caption = 'Visitors Summary';
                }
            }
            group(Control25)
            {
                systempart(Control24; Outlook) { }
            }
            group(Control23)
            {
                part(Control22; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control21; "Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control20; MyNotes) { }
            }
        }
    }

    actions
    {
        area(reporting)
        {

            group(SecReports)
            {
                caption = 'Security Reports';
                action(VisitorsByIndividual)
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitors By Individual';
                    Image = AllocatedCapacity;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Visitors Report";
                    ToolTip = 'Executes the Visitors By Individual action.';
                }
            }
            group(Reports)
            {
                Caption = 'FLT Reports';
                Image = SNInfo;
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Vehicle List";
                    ToolTip = 'Executes the Vehicle List action.';
                }
                action(Drivers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Driver List";
                    ToolTip = 'Executes the Driver List action.';
                }
                action(WT)
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Ticket';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "FLT Daily Work Ticket";
                    ToolTip = 'Executes the Work Ticket action.';
                }
                action("Transport Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Transport Requisition Report";
                    ToolTip = 'Executes the Transport Requisitions action.';
                }
                action("Vehicle Movement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Vehicle Movement Report";
                    ToolTip = 'Executes the Vehicle Movement action.';
                }

                action("Fleet Maintenance")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Maintenance Report";
                    ToolTip = 'Executes the Fleet Maintenance action.';
                }
            }


            group(ICTReports)
            {
                Caption = 'ICT Reports';
                Image = "1099Form";
                action("Ticket Status")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Ticket Status";
                    ToolTip = 'Executes the Ticket Status action.';
                }
                action("ICT Asset Register")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "ICT Asset Register";
                    ToolTip = 'Executes the ICT Asset Register action.';
                }

                action("Asset Movement Register")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Asset Movement Reg";
                    ToolTip = 'Executes the Asset Movement Register action.';
                }

            }

            group(SecSetup)
            {
                Caption = 'Security Setup';
                Image = LotInfo;
                action("<Page Security Setups>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Security Setup';
                    RunObject = Page "Security Setups";
                    ToolTip = 'Executes the Security Setup action.';
                }
            }
        }
        area(sections)
        {
            group(SecManagement)
            {
                Caption = 'Security Management';
                group(VisitorsManagement)
                {
                    Caption = 'Visitors Management';
                    Image = FixedAssets;

                    action(Allocations)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Visitors';
                        Image = Registered;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Sec-Visitor Management (New)";
                        ToolTip = 'Executes the New Visitors action.';
                    }
                    action(ActiveVisitors)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Active Visitors';
                        RunObject = Page "Sec-Visitor Manager (Active)";
                        ToolTip = 'Executes the Active Visitors action.';
                    }
                    action(ClearedVisitors)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleared Visitors';
                        Image = Aging;
                        Promoted = true;
                        RunObject = Page "Sec-Visitor Manager (Cleared)";
                        ToolTip = 'Executes the Cleared Visitors action.';
                    }

                }
                group(Gatepass)
                {
                    Caption = 'GatePass Management';
                    action(GatePassList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Gate Pass';
                        Image = Aging;
                        Promoted = true;
                        RunObject = Page "Gatepass List";
                        ToolTip = 'Executes the Gate Pass action.';
                    }
                    action(GatePassListApproved)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Approved Gate Pass';
                        Image = Aging;
                        Promoted = true;
                        RunObject = Page "Approved Gatepass List";
                        ToolTip = 'Executes the Approved Gate Pass action.';
                    }
                    action(GatePassListRep)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Gate Pass Report';
                        Image = Aging;
                        Promoted = true;
                        RunObject = report "Gate Pass Report";
                        ToolTip = 'Executes the Gate Pass Report action.';
                    }
                }
                group("Guards Management")
                {
                    action(DailyShift)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Guards Shift Register';
                        RunObject = Page "Security Daily Shift List";
                        ToolTip = 'Executes the Guards Shift Register action.';
                    }
                    action(SecComp)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Security Company';
                        RunObject = Page "Security Company";
                        ToolTip = 'Executes the Security Company action.';
                    }
                    action(SecShift)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Security Shift';
                        RunObject = Page "Security Shift";
                        ToolTip = 'Executes the Security Shift action.';
                    }
                    action(SecSection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Security Sections';
                        RunObject = Page "Security Sections";
                        ToolTip = 'Executes the Security Sections action.';
                    }
                }
                group("Cleaning Management")
                {
                    action(CleaningDailyShift)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleaners Shift Register';
                        RunObject = Page "Cleaning Daily Shift List";
                        ToolTip = 'Executes the Cleaners Shift Register action.';
                    }
                    action(CleanComp)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleaning Company';
                        RunObject = Page "Cleaning Company";
                        ToolTip = 'Executes the Cleaning Company action.';
                    }
                    action(CleanShift)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleaning Shift';
                        RunObject = Page "Cleaning Shift";
                        ToolTip = 'Executes the Cleaning Shift action.';
                    }
                    action(CleanSection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleaning Sections';
                        RunObject = Page "Cleaning Sections";
                        ToolTip = 'Executes the Cleaning Sections action.';
                    }
                }

                group(hist)
                {
                    Caption = 'History';
                    Image = History;
                    action(Action28)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleared Visitors';
                        RunObject = Page "Sec-Visitor Manager (Cleared)";
                        ToolTip = 'Executes the Cleared Visitors action.';
                    }


                }
                group("Incident Management")
                {
                    Caption = 'Incident Management';
                    action("<Page Incident Details>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Incidents Details';
                        RunObject = Page "Incident Details";
                        ToolTip = 'Executes the Incidents Details action.';
                    }
                    action("<Page Incident pending>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Incidents Pending';
                        RunObject = Page "Incidents Pending";
                        ToolTip = 'Executes the Incidents Pending action.';
                    }
                    action("Incident Cleared")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cleared Incidents';
                        RunObject = Page "Incidents Cleared";
                        ToolTip = 'Executes the Cleared Incidents action.';
                    }

                }
            }
            group(AssetMang)
            {
                caption = 'Asset Management';
                action(AssetInfo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Information Register';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Info Register List";
                    ToolTip = 'Executes the Asset Information Register action.';
                }
                action(AssetRep)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Repair List - Vehicles';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Repair List  Vehicles";
                    ToolTip = 'Executes the Asset Repair List - Vehicles action.';
                }
                action(AssetRep2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Repair List - Others';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Repair List  Others";
                    ToolTip = 'Executes the Asset Repair List - Others action.';
                }
                action(MaintananceType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintanance Type';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Maintanance Type";
                    ToolTip = 'Executes the Maintanance Type action.';
                }
                action(AssetRep3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Transfer';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Transfer List";
                    ToolTip = 'Executes the Asset Transfer action.';
                }
                action(AssetRep4)
                {
                    ApplicationArea = Basic;
                    Caption = 'Minor Asset Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Minor Asset Requisition List";
                    ToolTip = 'Executes the Minor Asset Requisition action.';
                }
            }

            group(ICTReq)
            {
                caption = 'ICT Requisitions';
                action(ICT1)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT General Requisition";
                    ToolTip = 'Executes the ICT Requisition action.';
                }

                action(ICT3)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Submitted Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Requisition List";
                    RunPageLink = "Resolution Status" = filter(Submitted);
                    ToolTip = 'Executes the ICT Submitted Requisition action.';
                }
                action(ICT5)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Resolved Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Requisition List";
                    RunPageLink = "Resolution Status" = filter("Resolved Waiting User Confirmation" | Cancelled);
                    ToolTip = 'Executes the ICT Resolved Requisition action.';
                }
                action(ICT9)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Escalated Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Requisition List";
                    RunPageLink = "Resolution Status" = filter(InProgress);
                    ToolTip = 'Executes the ICT Escalated Requisition action.';
                }
                action(ICT8)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Closed Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Requisition List";
                    RunPageLink = "Resolution Status" = filter(Closed);
                    ToolTip = 'Executes the ICT Closed Requisition action.';
                }

                action(ICT4)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Requisition Category';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Requisition Category";
                    ToolTip = 'Executes the ICT Requisition Category action.';
                }
                action(ICTAsset)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Asset Register';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "ICT Asset Register List";
                    ToolTip = 'Executes the ICT Asset Register action.';
                }
                action(AssetMvt)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Asset Movement Register';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Movement Register List";
                    ToolTip = 'Executes the ICT Asset Movement Register action.';
                }
                action(ICT6)
                {
                    ApplicationArea = Basic;
                    Caption = 'ICT Service/maintenance Request';
                    Image = ListPage;
                    Promoted = true;
                    RunObject = page "ICT Service/Maintenance Req";
                    ToolTip = 'Executes the ICT Service/maintenance Request action.';
                }
            }
            group(FleetManag)
            {
                Caption = 'Fleet Management';
                group(Vehicle_Man)
                {
                    Caption = 'Vehicle Management';
                    Image = AnalysisView;
                    action(VehicleCard)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vehicle Card';
                        Image = Register;
                        Promoted = true;
                        RunObject = Page "Flt Vehicle Card List";
                        ToolTip = 'Executes the Vehicle Card action.';
                    }
                    action(DriverCard)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Driver Card';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "Flt Driver List";
                        ToolTip = 'Executes the Driver Card action.';
                    }
                }
                group(Transport_re)
                {
                    Caption = 'Transport Requisitions';
                    Image = Travel;
                    action(TransportRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transport Requisition';
                        RunObject = Page "FLT Transport Requisition List";
                        ToolTip = 'Executes the Transport Requisition action.';
                    }
                    action(SubmittedTransportRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Submitted Transport Requisition';
                        RunObject = Page "FLT Submitted Transport List";
                        ToolTip = 'Executes the Submitted Transport Requisition action.';
                    }
                    action(ApprovedTransportRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Approved Transport Requisition';
                        RunObject = Page "FLT Approved transport Req";
                        ToolTip = 'Executes the Approved Transport Requisition action.';
                    }
                    action(ClosedTransportRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Closed Transport Requisition';
                        RunObject = Page "FLT Transport - Closed List";
                        ToolTip = 'Executes the Closed Transport Requisition action.';
                    }
                }
                group(Safari_Notices)
                {
                    Caption = 'Travel Memos';
                    Image = ResourcePlanning;
                    action(Travel_Notices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Travel Memos';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "FLT Safari Notices List";
                        ToolTip = 'Executes the Travel Memos action.';
                    }
                    action(ApprovedTravelNotices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Approved Travel Memos';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Posted Safari Notices List";
                        ToolTip = 'Executes the Approved Travel Memos action.';
                    }
                }
                group(Fuel_req1)
                {
                    Caption = 'Fuel Requisitions';
                    Image = Intrastat;
                    action(Fuel_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fuel Requisitions';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "FLT Fuel Requestion List";
                        ToolTip = 'Executes the Fuel Requisitions action.';
                    }
                    action(sub_Fuel_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Submitted Fuel Requisitions';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Fuel Req Submitted List";
                        ToolTip = 'Executes the Submitted Fuel Requisitions action.';
                    }
                    action(Unpaid_Fuel_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Unpaid Fuel Requisitions';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Fuel Req Unpaid";
                        ToolTip = 'Executes the Unpaid Fuel Requisitions action.';
                    }
                    action(Closed_Fuel_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Closed/Paid Fuel Requisitions';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Fuel Req Closed List";
                        ToolTip = 'Executes the Closed/Paid Fuel Requisitions action.';
                    }
                    action(Batch_fuel_Pay)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Batch Fuel Payments';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Fule Payment Batch List";
                        ToolTip = 'Executes the Batch Fuel Payments action.';
                    }
                }
                group("Work Tickets")
                {
                    Caption = 'Work Tickets';
                    Image = Marketing;
                    action(workTick)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Daily Work Tickets';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "FLT Daily Work Ticket List";
                        ToolTip = 'Executes the Daily Work Tickets action.';
                    }
                    action(Closed_Work_Tick)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Closed Daily Work Tickets';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Closed Work Ticket List";
                        ToolTip = 'Executes the Closed Daily Work Tickets action.';
                    }
                }
                group(Maint_Req)
                {
                    Caption = 'Maintenance Request';
                    Image = Receivables;
                    action(main_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Maintenance Request';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "FLT Maintenance Request List";
                        ToolTip = 'Executes the Maintenance Request action.';
                    }
                    action(Other_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Other Maintenance Request';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "Other Maintenance Request List";
                        ToolTip = 'Executes the Other Maintenance Request action.';
                    }
                    action(subMmain_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Submitted Maintenance Request';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Maintenance Req Sub. List";
                        ToolTip = 'Executes the Submitted Maintenance Request action.';
                    }
                    action(Appr_main_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Approved Maintenance Request';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "FLT Approved  Maintenance Req";
                        ToolTip = 'Executes the Approved Maintenance Request action.';
                    }
                    action(Closed_main_Req)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Closed Maintenance Request';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT ClosedMaintenance Req List";
                        ToolTip = 'Executes the Closed Maintenance Request action.';
                    }
                }
                group(Setup)
                {
                    Caption = 'Setups';
                    Image = Setup;
                    action(FleetMan_setup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fleet Mgt Setup';
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = false;
                        RunObject = Page "FLT Fleet Mgt Setup";
                        ToolTip = 'Executes the Fleet Mgt Setup action.';
                    }
                    action(flet_man_app_setup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fleet Mgt Approval Setup';
                        Image = History;
                        Promoted = true;
                        RunObject = Page "FLT Mgt Approval Setup";
                        ToolTip = 'Executes the Fleet Mgt Approval Setup action.';
                    }
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action(StoresRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action(StaffClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action(PurchaseRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action(ImprestSurrender)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Surrender';
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action(ImprestRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(LeaveApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("<Page My Approved Leaves>")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }
        }
    }
}

