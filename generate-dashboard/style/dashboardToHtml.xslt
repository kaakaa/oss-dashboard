<?xml version="1.0" encoding="UTF-8"?>

<!--
# Copyright 2015-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
-->

<xsl:stylesheet method="html" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">

<!--
<github-dashdata dashboard='ORG'>
 <metadata>
  <navigation>
    <organization>org1</organization>
    <organization>org2</organization>
  </navigation>
  <reports>
    <report>DocsReporter</report>
    <report>CustomReporter</report>
  </reports>
  <db-reports>
    <db-report>DocsReporter</db-report>
    <db-report>CustomReporter</db-report>
  </db-reports>
 </metadata>
 <organization name='ORG'>
  <team name='NAME'>
    <description>XYZ</description>
    <repos>
        <repo>repo1</repo>
    </repos>
    <members>
      <member>member1</member>
    </members>
  </team>
  <repo name='repo1' private='false' fork='false' open_issue_count='0' has_wiki='false' language='Blah' stars='3' watchers='14' forks='0'>
    <description>ABC</description>
  </repo>
  <member internal='mem1' mail='mem1@example.com' disabled_2fa='true' name='member1'/>
  <github-review>
    <organization name=''>
      <repo name=''>
        <license>
        <reporting>
      </repo>
    </organization>
  </github-review>
 </organization>
</github-dashdata>

-->

  <xsl:template match="github-dashdata">
    <xsl:variable name="dashboardname" select="@dashboard"/>
    <xsl:variable name="orgname" select="organization/@name"/>
    <html>
      <head>
        <title>GitHub Dashboard: <xsl:value-of select='@dashboard'/><xsl:if test='@team'>/<xsl:value-of select='@team'/></xsl:if></title>
        <meta charset="utf-8"/>

        <!-- Lots of CDN usage here - you should replace this if you want to control the source of the JS/CSS -->
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/octicons/3.1.0/octicons.css" />
        <link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" />
        <!-- xsl comment needed in JS to avoid an empty tag -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"><xsl:comment/></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"><xsl:comment/></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/flot/0.8.3/jquery.flot.min.js"><xsl:comment/></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/flot/0.8.3/jquery.flot.stack.min.js"><xsl:comment/></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/flot/0.8.3/jquery.flot.pie.min.js"><xsl:comment/></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.24.2/js/jquery.tablesorter.js"><xsl:comment/></script>

        <!-- This is inline to make for a simpler deliverable -->
        <style>
            html{font-size:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;}
            body{margin:0;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:12px;line-height:17px;color:#222222;background-color:#e8e8e8;}

            h1,h2,h3,h4,h5{margin:0;font-family:inherit;font-weight:700;line-height:1;color:#333333;text-rendering:optimizelegibility;}
            h1{font-size:30px;line-height:36px;}
            h2{font-size:24px;line-height:36px;}
            h3{font-size:18px;line-height:27px;}
            h4{font-size:14px;line-height:18px;}
            h5{font-size:12px;line-height:18px;}

            .caret{display:inline-block;width:0;height:0;vertical-align:top;border-top:4px solid #000000;border-right:4px solid transparent;border-left:4px solid transparent;content:"";}

            .well{min-height:20px;margin-bottom:20px;background-color:#ffffff;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;padding:8px 12px;border:1px solid #eeeeee;-webkit-box-shadow:0 1px 2px #888888;-moz-box-shadow:0 1px 2px #888888;box-shadow:0 1px 2px #888888;}

            .data-grid{width:100%;}
            .data-grid thead{color:#999999;font-size:10px;border-bottom:1px solid #aaaaaa;text-align:left;}
            .data-grid thead th{font-weight:normal;}
            .data-grid td{vertical-align:top;font-size:10px;}
            .data-grid tbody tr{border-bottom:1px solid #e8e8e8;}
            .data-grid tbody tr:last-child{border-bottom:0px none #e8e8e8;}
            .data-grid a{font-weight:bold;}
            .data-grid thead th{text-transform:uppercase;color:#888;font-size:10px;font-weight:bold;}
            .data-grid td{line-height:14px;padding:5px 2px;}
            .data-grid-sortable{width:100%;}

            .tablesorter-header{cursor:pointer;white-space:nowrap;}
            .tablesorter-header.tablesorter-headerAsc .tablesorter-header-inner,.tablesorter-header.tablesorter-headerDesc .tablesorter-header-inner{color:#ff5522;}
            .tablesorter-header:hover{color:#ff5522;background-color:#f2f8fa;}

            .nav{margin-left:0;margin-bottom:17px;list-style:none;}
            .nav>li>a{display:block;}
            .nav>li>a:hover,.nav>li>a:focus{text-decoration:none;background-color:#aaaaaa;}
            .nav>li>a>img{max-width:none;}
            .nav>.pull-right{float:right;}
            .nav li+.nav-header{margin-top:9px;}
            .nav-list>li>a{margin-left:-15px;margin-right:-15px;text-shadow:0 1px 0 rgba(255, 255, 255, 0.5);}
            .nav-list>li>a{padding:3px 15px;}
            .nav-list>.active>a,.nav-list>.active>a:hover,.nav-list>.active>a:focus{color:#ffffff;text-shadow:0 -1px 0 rgba(0, 0, 0, 0.2);background-color:#0088cc;}
            .nav-tabs{*zoom:1;}
            .nav-tabs:before,.nav-tabs:after{display:table;content:"";line-height:0;}
            .nav-tabs:after{clear:both;}
            .nav-tabs>li{float:left;}
            .nav-tabs>li>a{padding-right:12px;padding-left:12px;margin-right:2px;line-height:14px;}
            .nav-tabs{border-bottom:1px solid #ddd;}
            .nav-tabs>li{margin-bottom:-1px;}
            .nav-tabs>li>a{padding-top:8px;padding-bottom:8px;line-height:17px;border:1px solid transparent;-webkit-border-radius:4px 4px 0 0;-moz-border-radius:4px 4px 0 0;border-radius:4px 4px 0 0;}
            .nav-tabs>li>a:hover,.nav-tabs>li>a:focus{border-color:#aaaaaa #aaaaaa #dddddd;}
            .nav-tabs>.active>a,.nav-tabs>.active>a:hover,.nav-tabs>.active>a:focus{color:#555555;background-color:#e8e8e8;border:1px solid #ddd;border-bottom-color:transparent;cursor:default;}

            .nav .dropdown-toggle .caret{border-top-color:#0088cc;border-bottom-color:#0088cc;margin-top:6px;}
            .nav .dropdown-toggle:hover .caret,.nav .dropdown-toggle:focus .caret{border-top-color:#ff5522;border-bottom-color:#ff5522;}
            .nav-tabs .dropdown-toggle .caret{margin-top:8px;}

            /* Dashboard specific */
            .labelColor {padding: 3px;-webkit-box-shadow:0 1px 2px #888888;-moz-box-shadow:0 1px 2px #888888;box-shadow:0 1px 2px #888888;}
        </style>

        <!-- This will fail - but if you drop a theme.css file in you can add your own Bootstrap Theme :) -->
        <link type="text/css" rel="stylesheet" href="bootstrap-theme.css" />
      </head>
      <body class="inverse">
        <ul class="nav nav-tabs pull-right" role="tablist">
          <xsl:if test="organization/team">
          <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
              Team <span class="caret"></span>
            </a>
            <ul class="dropdown-menu" role="menu">
              <xsl:for-each select='organization/team'>
                <xsl:variable name="teamlink" select="@slug"/>
                <xsl:variable name="orgname2" select="../@name"/>
                <li><a href="{$orgname2}-team-{$teamlink}.html"><xsl:value-of select="../@name"/>::<xsl:value-of select="@name"/></a></li>
              </xsl:for-each>
            </ul>
          </li>
          </xsl:if>
          <xsl:if test="organization">
          <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
              Organization <span class="caret"></span>
            </a>
            <ul class="dropdown-menu" role="menu">
              <xsl:for-each select="metadata/navigation/organization">
                <xsl:variable name="org" select="."/>
                <li><a href="{$org}.html"><xsl:value-of select="."/></a></li>
              </xsl:for-each>
            </ul>
          </li>
          </xsl:if>
        </ul>

        <div class="well">
          <xsl:variable name="logo" select="@logo"/>
          <xsl:variable name="orgDescription" select="organization/description"/>
          <h2>GitHub Dashboard: <xsl:if test="@logo"><a rel="tooltip" title="{$orgDescription}" href="https://github.com/{$orgname}"><img width="35" height="35" src="{$logo}&amp;s=35"/></a></xsl:if><xsl:value-of select='@dashboard'/><xsl:if test='@team'>/<xsl:value-of select='@team'/></xsl:if></h2><br/>
          <ul id="tabs" class="nav nav-tabs">
            <li class="active"><a href="#overview" data-toggle="tab">Overview</a></li>
            <li><a href="#repositories" data-toggle="tab">Repositories (<xsl:value-of select="count(organization/repo)"/>)</a></li>
            <li><a href="#repometrics" data-toggle="tab">Repository Metrics (<xsl:value-of select="count(organization/repo)"/>)</a></li>
            <li><a href="#issues" data-toggle="tab">Issues (<xsl:value-of select="count(organization/repo/issues/issue[@pull_request='false'])"/>)</a></li>
            <li><a href="#pullrequests" data-toggle="tab">Pull Requests (<xsl:value-of select="count(organization/repo/issues/issue[@pull_request='true'])"/>)</a></li>
            <xsl:if test="organization/team">
            <li><a href="#teams" data-toggle="tab">Teams (<xsl:value-of select="count(organization/team)"/>)</a></li>
            </xsl:if>
            <xsl:if test="organization/member">
            <li><a href="#members" data-toggle="tab">Members (<xsl:value-of select="count(organization/member[not(@login=preceding::*/@login)])"/>)</a></li>
            </xsl:if>
            <xsl:if test="organization/repo/collaborators/collaborator">
            <li><a href="#collaborators" data-toggle="tab">Collaborators (<xsl:value-of select="count(organization/repo/collaborators/collaborator)"/>)</a></li>
            </xsl:if>
            <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">GitHub Reports <span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
                <xsl:for-each select="metadata/db-reports/db-report">
                  <xsl:variable name="report" select="@key"/>
                  <li><a href="#{$report}" data-toggle="tab"><xsl:value-of select="@name"/>(<xsl:value-of select="count(/github-dashdata/organization/github-db-report/organization/db-reporting[@type=$report and not(text()=preceding::db-reporting[@type=$report]/text())])"/>)</a></li> 
                </xsl:for-each>
              </ul>
            </li>
            <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Source Reports <span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
                <xsl:for-each select="metadata/reports/report">
                  <xsl:variable name="report" select="@key"/>
                  <li><a href="#{$report}" data-toggle="tab"><xsl:value-of select="@name"/>(<xsl:value-of select="count(/github-dashdata/organization/github-review/organization/repo/reporting[@type=$report])"/>)</a></li> 
                </xsl:for-each>
              </ul>
            </li>
          </ul>
          <div id="tabcontent" class="tab-content">

            <div class="tab-pane active" id="overview">

            <table cellpadding="10px" width="100%"><tr>
            <td class="left" style="vertical-align:top">
              <xsl:if test="count(organization)=1">
                <h4>Organization:</h4>
                <table class="data-grid">
                  <xsl:if test="organization/@name"><tr><td>Login</td><td><xsl:value-of select="organization/@name"/></td></tr></xsl:if>
                  <xsl:if test="organization/name"><tr><td>Name</td><td><xsl:value-of select="organization/name"/></td></tr></xsl:if>
                  <xsl:if test="organization/url">
                    <xsl:variable name='org_url' select="organization/url"/>
                    <tr><td>URL</td><td><a href="{$org_url}"><xsl:value-of select="organization/url"/></a></td></tr>
                  </xsl:if>
                  <xsl:if test="organization/email"><tr><td>Email</td><td><xsl:value-of select="organization/email"/></td></tr></xsl:if>
                  <xsl:if test="organization/location"><tr><td>Location</td><td><xsl:value-of select="organization/location"/></td></tr></xsl:if>
                  <xsl:if test="organization/created_at"><tr><td>Create Date</td><td><xsl:value-of select="substring(organization/created_at,1,10)"/></td></tr></xsl:if>
                </table>
              </xsl:if>
              <xsl:if test="count(organization)>1">
                <h4>Organizations:</h4>
                <table class="data-grid">
                 <xsl:for-each select="organization">
                  <xsl:variable name="orgname2" select="@name"/>
                  <xsl:variable name="logo2" select="@logo"/>
                  <xsl:variable name="orgDescription2" select="organization/description"/>
                  <tr>
                    <td><xsl:if test="@logo2"><a rel="tooltip" title="{$orgDescription2}" href="https://github.com/{$orgname2}"><img width="35" height="35" src="{$logo2}&amp;s=35"/></a></xsl:if><a href="{$orgname2}.html"><xsl:value-of select="@name"/></a></td>
                    <td></td>
                  </tr>
                 </xsl:for-each>
                </table>
              </xsl:if>
            </td>
            <td class="center" style="vertical-align:top">
                <h4>Repo Count over Time</h4><br/>
                <div id="repoCountChart" style="height:150px;width:400px;"><xsl:comment/></div><br/>
            </td>
            <td class="right" style="vertical-align:top">
              <h4>Recent Repositories:</h4>
              <table class='data-grid'>
                <xsl:for-each select="organization/repo">
                  <xsl:sort select="@created_at" order="descending"/>
                  <xsl:variable name='repo_name' select="@name"/>
                  <xsl:variable name='orgname2' select="../@name"/>
                  <xsl:if test="position() &lt;= 5">
                    <tr><td>
                      <a href="https://github.com/{$orgname2}/{$repo_name}"><xsl:value-of select='substring(@created_at,1,10)'/></a> - <xsl:value-of select='@name'/>
                      <xsl:if test="@private='true'">
                         <sup><span style="margin-left: 5px" class="octicon octicon-lock"></span></sup>
                      </xsl:if>
                      <xsl:if test="@fork='true'">
                         <sup><span style="margin-left: 5px" class="octicon octicon-repo-forked"></span></sup>
                      </xsl:if>
                    </td></tr>
                  </xsl:if>
                </xsl:for-each>
              </table>
              <xsl:if test="organization/repo/release-data/release">
              <hr/>
              <h4>Recent Releases:</h4>
              <table class='data-grid'>
                <xsl:for-each select="organization/repo/release-data/release">
                  <xsl:sort select="@published_at" order="descending"/>
                  <xsl:variable name='release_url' select="@url"/>
                  <xsl:if test="position() &lt;= 5">
                    <tr><td><a href="{$release_url}"><xsl:value-of select='substring(@published_at,1,10)'/></a> - <xsl:value-of select='../../@name'/>: <xsl:value-of select='.'/></td></tr>
                  </xsl:if>
                </xsl:for-each>
              </table>
              </xsl:if>
            </td></tr></table>

            </div>

            <div class="tab-pane" id="repositories">
             <div class="data-grid-sortable tablesorter">
              <table id='repoTable' class='data-grid'>
              <thead>
              <tr><th>Repo</th><th>Description</th><xsl:if test="organization/team"><th>Teams</th></xsl:if>
              </tr>
              </thead>
              <tbody>
              <xsl:for-each select="organization/repo">
              <xsl:variable name="reponame" select="@name"/>
              <xsl:variable name="orgname2" select="../@name"/>
              <xsl:variable name="homepage" select="@homepage"/>
                <tr><td>
                <a href="https://github.com/{$orgname2}/{$reponame}"><xsl:value-of select="@name"/></a>
                <xsl:if test="@private='true'">
                   <sup><span style="margin-left: 5px" class="octicon octicon-lock"></span></sup>
                </xsl:if>
                <xsl:if test="@fork='true'">
                   <sup><span style="margin-left: 5px" class="octicon octicon-repo-forked"></span></sup>
                </xsl:if>
                </td>
                <td><xsl:value-of select="description"/><xsl:if test='@homepage!=""'> - <a href="{$homepage}"><xsl:value-of select="@homepage"/></a></xsl:if></td>
                 <xsl:if test="../team">
                  <td><ul style='list-style-type: none;'><xsl:for-each select='/github-dashdata/organization[@name=$orgname2]/team[repos/repo=$reponame]'>
                       <xsl:if test="@name != 'private read-only'">
                        <li><xsl:value-of select='@name'/></li>
                       </xsl:if>
                      </xsl:for-each></ul>
                  </td>
                 </xsl:if>
                </tr>
              </xsl:for-each>
              </tbody>
              </table>
             </div>
            </div>
            <div class="tab-pane" id="repometrics">
             <div class="data-grid-sortable tablesorter">
              <table id='repoMetricsTable' class='data-grid'>
              <thead>
              <tr><th>Repo</th><th><a href="#" rel="tooltip" title="As Reported by GitHub/Licensee with confidence percentage">Apparent License</a></th><th>Language</th>
                  <th>Created</th>
                  <th>Pushed</th>
                  <th>Updated</th>
                  <th><a href="#" rel="tooltip" title="Git Size in MB">Size</a></th>
                  <th><a href="#" rel="tooltip" title="# of Stars"><span class="octicon octicon-star"></span></a></th>
                  <th><a href="#" rel="tooltip" title="# of Watchers"><span class="octicon octicon-eye"></span></a></th>
                  <th><a href="#" rel="tooltip" title="# of Forks"><span class="octicon octicon-repo-forked"></span></a></th>
                  <th><a href="#" rel="tooltip" title="Issue Resolution %age"><span class="octicon octicon-issue-opened"></span></a></th>
                  <th><a href="#" rel="tooltip" title="Pull Request Resolution %age"><span class="octicon octicon-git-pull-request"></span></a></th>
              </tr>
              </thead>
              <tbody>
              <xsl:for-each select="organization/repo">
              <xsl:variable name="orgname2" select="../@name"/>
              <xsl:variable name="reponame" select="@name"/>
                <tr><td>
                <a href="https://github.com/{$orgname2}/{$reponame}"><xsl:value-of select="@name"/></a>
                <xsl:if test="@private='true'">
                   <sup><span style="margin-left: 5px" class="octicon octicon-lock"></span></sup>
                </xsl:if>
                <xsl:if test="@fork='true'">
                   <sup><span style="margin-left: 5px" class="octicon octicon-repo-forked"></span></sup>
                </xsl:if>
                </td>
                <td>
                  <xsl:if test="/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/license/@confidence">
                    <xsl:variable name="licenseFile" select="/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/license/@file"/>
                    <a href="https://github.com/{$orgname2}/{$reponame}/blob/master/{$licenseFile}"><xsl:value-of select="/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/license"/> (<xsl:value-of select="round(/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/license/@confidence)"/>%)</a>
                  </xsl:if>
                </td>
                <td><xsl:value-of select='@language'/></td>
                  <td><xsl:value-of select='substring(@created_at,1,10)'/></td>
                  <td><xsl:value-of select='substring(@pushed_at,1,10)'/></td>
                  <td><xsl:value-of select='substring(@updated_at,1,10)'/></td>
                  <td><xsl:value-of select="format-number(format-number(@size, '#.0') div 1024, '#.#')"/></td>
                  <td><xsl:value-of select='@stars'/></td>
                  <td><xsl:value-of select='@watchers'/></td>
                  <td><xsl:value-of select='@forks'/></td>
                  <xsl:if test='@closed_issue_count=0 and @open_issue_count=0'>
                    <td>&#8734;% (0 / 0)</td>
                  </xsl:if>
                  <xsl:if test='@closed_issue_count!=0 or @open_issue_count!=0'>
                    <td><xsl:value-of select='round(100 * @closed_issue_count div (@open_issue_count + @closed_issue_count))'/>% (<xsl:value-of select='@closed_issue_count'/> / <xsl:value-of select='@open_issue_count + @closed_issue_count'/>)</td>
                  </xsl:if>

                  <xsl:if test='@closed_pr_count=0 and @open_pr_count=0'>
                    <td>&#8734;% (0 / 0)</td>
                  </xsl:if>
                  <xsl:if test='@closed_pr_count!=0 or @open_pr_count!=0'>
                    <td><xsl:value-of select='round(100 * @closed_pr_count div (@open_pr_count + @closed_pr_count))'/>% (<xsl:value-of select='@closed_pr_count'/> / <xsl:value-of select='@open_pr_count + @closed_pr_count'/>)</td>
                  </xsl:if>
                </tr>
              </xsl:for-each>
              </tbody>
              </table>
             </div>
            </div>
            <div class="tab-pane" id="issues">
             <table width="100%">
              <tr>
              <td style="text:align=left">
                <h4>Issue Count over Time</h4><br/>
                <div id="issueCountChart" class="right" style="height:100px;width:300px;"><xsl:comment/></div><br/>
              </td>
              <td style="text:align=center">
                <h4>Time to Close an Issue</h4><br/>
                <div id="issueTimeToCloseChart" style="height:100px;width:330px;"><xsl:comment/></div><br/>
              </td>
              <td style="text:align=right">
                <h4>Contributions</h4><br/>
                <div id="issueCommunityPieChart" style="height:100px;width:270px;"><xsl:comment/></div><br/>
              </td>
              </tr>
             </table>
             <hr/>
             <div class="data-grid-sortable tablesorter">
              <table id='issueTable' class='data-grid'>
                <thead>
                <tr><th>Open Issue</th><th>Title</th><th>Labels</th><th>Age</th><th>Created</th><th>Updated</th><th>Requester</th><th>Comments</th></tr>
                </thead>
                <tbody>
                <xsl:for-each select="organization/repo">
                  <xsl:variable name="orgname2" select="../@name"/>
                  <xsl:variable name="reponame" select="@name"/>
                  <xsl:for-each select="issues/issue[@pull_request='false']">
                    <xsl:variable name="issuekey" select="@number"/>
                    <xsl:variable name="title" select="title"/>
                    <xsl:variable name="membername" select="@user"/>
                    <tr>
                      <td><span class="octicon octicon-issue-opened"></span> <a href="https://github.com/{$orgname2}/{$reponame}/issues/{$issuekey}"><xsl:value-of select="$reponame"/>-<xsl:value-of select='@number'/></a></td>
                      <td>"<xsl:value-of select='substring(title,1,144)'/>"</td>
                      <td>
                       <xsl:for-each select='label'>
                        <xsl:variable name='labelColor' select='@color'/>
                        <span class='labelColor' style='background-color: #{$labelColor}'><xsl:value-of select='.'/></span>
                       </xsl:for-each>
                      </td>
                      <td><xsl:value-of select='@age'/>d</td>
                      <td><xsl:value-of select='substring(@created_at,1,10)'/></td>
                      <td><xsl:value-of select='substring(@updated_at,1,10)'/></td>
                      <td>
                      <xsl:if test="/github-dashdata/organization[@name=$orgname]/member[@login=$membername]">
                       <!-- TODO: How to allow users to pass in a url and member@internal to their internal directories? -->
                       <xsl:if test="$logo">
                        <span style="margin-right: 2px;"><sup><img src="{$logo}" width="8" height="8"/></sup></span>
                       </xsl:if>
                       <xsl:if test="not($logo)">
                        <span style="margin-right: 2px;"><sup>&#x2699;</sup></span>
                       </xsl:if>
                      </xsl:if>
                        <a href="https://github.com/{$membername}"><xsl:value-of select="@user"/></a>
                      </td>
                      <td><xsl:value-of select='@comments'/></td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
              </table>
             </div>
            </div>
            <div class="tab-pane" id="pullrequests">
             <table width="100%">
              <tr>
              <td style="text:align=left">
                <h4>Pull Request Count over Time</h4><br/>
                <div id="pullRequestCountChart" class="right" style="height:100px;width:300px;"><xsl:comment/></div><br/>
              </td>
              <td style="text:align=center">
                <h4>Time to Close a Pull Request</h4><br/>
                <div id="prTimeToCloseChart" style="height:100px;width:330px;"><xsl:comment/></div><br/>
              </td>
              <td style="text:align=right">
                <h4>Contributions</h4><br/>
                <div id="prCommunityPieChart" style="height:100px;width:270px;"><xsl:comment/></div><br/>
              </td>
              </tr>
             </table>
             <hr/>
             <div class="data-grid-sortable tablesorter">
              <table id='prTable' class='data-grid'>
                <thead>
                <tr><th>Open Pull Request</th><th>Title</th><th>Labels</th><th>Age</th><th>Created</th><th>Updated</th><th>Requester</th><th>Comments</th><th># Files Changed</th><th># New Lines</th><th># Removed Lines</th></tr>
                </thead>
                <tbody>
                <xsl:for-each select="organization/repo">
                  <xsl:variable name="orgname2" select="../@name"/>
                  <xsl:variable name="reponame" select="@name"/>
                  <xsl:for-each select="issues/issue[@pull_request='true']">
                    <xsl:variable name="issuekey" select="@number"/>
                    <xsl:variable name="title" select="title"/>
                    <xsl:variable name="membername" select="@user"/>
                    <tr>
                      <td><span class="octicon octicon-issue-opened"></span> <a href="https://github.com/{$orgname2}/{$reponame}/issues/{$issuekey}"><xsl:value-of select="$reponame"/>-<xsl:value-of select='@number'/></a></td>
                      <td>"<xsl:value-of select='substring(title,1,144)'/>"</td>
                      <td>
                       <xsl:for-each select='label'>
                        <xsl:variable name='labelColor' select='@color'/>
                        <span class='labelColor' style='background-color: #{$labelColor}'><xsl:value-of select='.'/></span>
                       </xsl:for-each>
                      </td>
                      <td><xsl:value-of select='@age'/>d</td>
                      <td><xsl:value-of select='substring(@created_at,1,10)'/></td>
                      <td><xsl:value-of select='substring(@updated_at,1,10)'/></td>
                      <td>
                      <xsl:if test="/github-dashdata/organization[@name=$orgname]/member[@login=$membername]">
                       <!-- TODO: How to allow users to pass in a url and member@internal to their internal directories? -->
                       <xsl:if test="$logo">
                        <span style="margin-right: 2px;"><sup><img src="{$logo}" width="8" height="8"/></sup></span>
                       </xsl:if>
                       <xsl:if test="not($logo)">
                        <span style="margin-right: 2px;"><sup>&#x2699;</sup></span>
                       </xsl:if>
                      </xsl:if>
                        <a href="https://github.com/{$membername}"><xsl:value-of select="@user"/></a>
                      </td>
                      <td><xsl:value-of select='@comments'/></td>
                      <td><xsl:value-of select='@prFileCount'/></td>
                      <td>+<xsl:value-of select='@prAdditions'/></td>
                      <td>-<xsl:value-of select='@prDeletions'/></td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
              </table>
             </div>
            </div>
            <xsl:if test="organization/team">
            <div class="tab-pane" id="teams">
              <table id='teamTable' class='data-grid'>
                <thead>
                <tr><th>Team</th><th>Repos</th><th>Members</th></tr>
                </thead>
                <tbody>
                <xsl:for-each select="organization/team">
                  <xsl:variable name="orgname2" select="../@name"/>
                  <xsl:variable name="teamlink" select="@slug"/>
                  <tr><td><a href="https://github.com/orgs/{$orgname2}/teams/{$teamlink}"><xsl:value-of select="@name"/></a><br/>
                    <xsl:value-of select="description"/>
                  </td>
                  <td>
                  <ul style='list-style-type: none;'>
                  <xsl:for-each select="repos/repo">
                    <xsl:variable name="reponame" select="."/>
                    <li><a href="https://github.com/{$orgname2}/{$reponame}"><xsl:value-of select="."/></a></li>
                  </xsl:for-each>
                  </ul>
                  </td>
                  <td>
                  <ul style='list-style-type: none;'>
                  <xsl:for-each select="members/member">
                    <xsl:variable name="membername" select="."/>
                    <li>
                      <a href="https://github.com/{$membername}"><xsl:value-of select="."/></a></li>
                  </xsl:for-each>
                  </ul>
                  </td>
                  </tr>
                </xsl:for-each>
                </tbody>
              </table>
            </div>
            </xsl:if>
            <xsl:if test="organization/member">
            <div class="tab-pane" id="members">
             <div class="data-grid-sortable tablesorter">
              <table id='memberTable' class='data-grid'>
                <thead>
                <tr><th>GitHub login</th><th>Name</th><th>Email</th><th>Company</th><th>Employee login</th><th>2FA?</th></tr>
                </thead>
                <tbody>
                <xsl:for-each select="organization/member[not(@login=preceding::*/@login)]">
                  <xsl:variable name="memberlogin" select="@login"/>
                  <xsl:variable name="avatar" select="@avatar_url"/>
                  <tr><td><img width="35" height="35" src="{$avatar}&amp;s=35"/><a href="https://github.com/{$memberlogin}"><xsl:value-of select="@login"/></a></td>
                      <td><xsl:value-of select="name"/></td>
                      <td><xsl:value-of select="@email"/></td>
                      <td><xsl:value-of select="company"/></td>
                      <td>
                        <xsl:if test="not(@internal)"><span class="octicon octicon-question"></span></xsl:if>
                        <xsl:if test="@internal"><xsl:value-of select="@employee_email"/></xsl:if>
                      </td>
                      <td><xsl:if test="@disabled_2fa='false'">
                        <span style="display:none">1</span><span class="octicon octicon-check"></span>
                      </xsl:if>
                      <xsl:if test="@disabled_2fa='true'">
                        <span style="display:none">0</span>
                      </xsl:if></td>
                  </tr>
                </xsl:for-each>
                </tbody>
              </table>
             </div>
            </div>
            </xsl:if>
            <!-- TODO: Merge with member above into people? -->
            <xsl:if test="organization/repo/collaborators/collaborator">
            <div class="tab-pane" id="collaborators">
             <div class="data-grid-sortable tablesorter">
              <table id='collaboratorTable' class='data-grid'>
                <thead>
                <tr><th>Repository</th><th>Collaborators</th></tr>
                </thead>
                <tbody>
                <xsl:for-each select="organization/repo">
                  <xsl:if test="collaborators/collaborator">
                  <tr><td>
                    <xsl:variable name="reponame" select="@name"/>
                    <xsl:variable name="orgname2" select="../@name"/>
                    <a href="https://github.com/{$orgname2}/{$reponame}"><xsl:value-of select="@name"/></a>
                  </td>
                  <td><ul style='list-style-type: none;'>
                  <xsl:for-each select="collaborators/collaborator">
                    <xsl:variable name="collaborator" select="."/>
                    <li>
                      <xsl:if test="/github-dashdata/organization[@name=$orgname]/member[@login=$collaborator]">
                       <!-- TODO: How to allow users to pass in a url and member@internal to their internal directories? -->
                       <xsl:if test="$logo">
                        <span style="margin-right: 2px;"><sup><img src="{$logo}" width="8" height="8"/></sup></span>
                       </xsl:if>
                       <xsl:if test="not($logo)">
                        <span style="margin-right: 2px;"><sup>&#x2699;</sup></span>
                       </xsl:if>
                      </xsl:if>
                      <a href="https://github.com/{$collaborator}"><xsl:value-of select="."/></a>
                    </li>
                  </xsl:for-each></ul></td>
                  </tr>
                  </xsl:if>
                </xsl:for-each>
                </tbody>
              </table>
             </div>
            </div>
            </xsl:if>

            <!-- DB REPORTS -->
            <xsl:for-each select="metadata/db-reports/db-report">
              <xsl:variable name="report" select="@key"/>
              <xsl:variable name="columntypes" select="column-type"/>
            <div class="tab-pane" id="{$report}">
             <h3>GitHub Report: <xsl:value-of select="@name"/>
             (<xsl:value-of select="count(/github-dashdata/organization/github-db-report/organization/db-reporting[@type=$report and not(text()=preceding::db-reporting[@type=$report]/text())])"/>)</h3> <!-- bug: unable to show summary count within a team mode -->
             <p><xsl:value-of select="description"/></p>
             <div class="data-grid-sortable tablesorter">
              <table id='{$report}Table' class='data-grid'>
               <thead><tr>
               <xsl:for-each select="column-type">
                <th><xsl:value-of select="."/></th>
               </xsl:for-each>
               </tr></thead>
               <tbody>
                <xsl:for-each select="/github-dashdata/organization">
                  <xsl:variable name="orgname2" select="@name"/>
                  <xsl:for-each select="/github-dashdata/organization/github-db-report/organization[@name=$orgname2]/db-reporting[@type=$report and not(text()=preceding::db-reporting[@type=$report]/text())]">
                    <tr>
                     <xsl:if test="not(field)">
                      <xsl:call-template name="db-reporting-field">
                        <xsl:with-param name="orgname" select="$orgname2"/>
                        <xsl:with-param name="logo" select="$logo"/>
                        <xsl:with-param name="columntypes" select="$columntypes"/>
                        <xsl:with-param name="value" select="."/>
                        <xsl:with-param name="index" select="1"/>
                      </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="field">
                      <xsl:for-each select="field">
                       <xsl:call-template name="db-reporting-field">
                         <xsl:with-param name="orgname" select="$orgname2"/>
                         <xsl:with-param name="logo" select="$logo"/>
                         <xsl:with-param name="columntypes" select="$columntypes"/>
                         <xsl:with-param name="value" select="."/>
                         <xsl:with-param name="index" select="position()"/>
                       </xsl:call-template>
                      </xsl:for-each>
                     </xsl:if>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
               </tbody>
              </table>
             </div>
            </div>
            </xsl:for-each>

            <!-- SOURCE REPORTS -->
            <xsl:for-each select="metadata/reports/report">
              <xsl:variable name="report" select="@key"/>
            <div class="tab-pane" id="{$report}">
             <h3>Source Report: <xsl:value-of select="@name"/>
             (<xsl:value-of select="count(/github-dashdata/organization/github-review/organization/repo/reporting[@type=$report])"/>)</h3> <!-- bug: unable to show summary count within a team mode -->
             <p><xsl:value-of select="description"/></p>
             <div class="data-grid-sortable tablesorter">
              <table id='{$report}Table' class='data-grid'>
                <thead>
                <tr><th>Issue Found In</th><th>Details</th></tr> 
                </thead>
                <tbody>
                <xsl:for-each select="/github-dashdata/organization/repo">
                  <xsl:variable name="orgname2" select="../@name"/>
                  <xsl:variable name="reponame" select="@name"/>
                  <xsl:if test="/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/reporting[@type=$report]">
                    <tr>
                      <td><a href="https://github.com/{$orgname2}/{$reponame}"><xsl:value-of select="@name"/></a>
                        <xsl:if test="@private='true'">
                           <sup><span style="margin-left: 5px" class="octicon octicon-lock"></span></sup>
                        </xsl:if>
                      </td>
                      <td><ul style='list-style-type: none;'>
                      <xsl:for-each select="/github-dashdata/organization/github-review/organization[@name=$orgname2]/repo[@name=$reponame]/reporting[@type=$report]">
                        <xsl:variable name="file" select="file"/>
                        <xsl:variable name="lineno"><xsl:value-of select="file/@lineno"/></xsl:variable>
                        <xsl:variable name="linetxt">#L<xsl:value-of select="$lineno"/></xsl:variable>
                        <xsl:if test="file and file/@lineno">
                          <li><xsl:if test="message"><xsl:value-of select="message"/>: </xsl:if><a href="https://github.com/{$orgname2}/{$reponame}/tree/master/{$file}{$linetxt}"><xsl:value-of select="$file"/><xsl:value-of select="$linetxt"/></a><xsl:if test="string-length(match)>0"> - <xsl:value-of select="match"/></xsl:if></li>
                        </xsl:if>
                        <xsl:if test="file and not(file/@lineno)">
                          <li><xsl:if test="message"><xsl:value-of select="message"/>: </xsl:if><a href="https://github.com/{$orgname2}/{$reponame}/tree/master/{$file}"><xsl:value-of select="$file"/></a><xsl:if test="string-length(match)>0"> - <xsl:value-of select="match"/></xsl:if></li>
                        </xsl:if>
                        <xsl:if test="not(file) and file/@lineno">
                          <li>ERROR: Line number and no file. </li>
                        </xsl:if>
                        <xsl:if test="not(file) and not(file/@lineno)">
                          <li><xsl:value-of select="."/></li>
                        </xsl:if>
                      </xsl:for-each>
                      </ul></td>
                    </tr>
                  </xsl:if>
                </xsl:for-each>
                </tbody>
              </table>
             </div>
            </div>
            </xsl:for-each>

          </div>
        </div>
          <div class="pull-right"><xsl:value-of select="metric/@start-time"/></div>

<!-- The years are hardcoded :( -->
<script>
publicRepoCount=[
  [2010, <xsl:value-of select="count(organization/repo[@private='false' and '2010'>=substring(@created_at,1,4)])"/>],
  [2011, <xsl:value-of select="count(organization/repo[@private='false' and '2011'>=substring(@created_at,1,4)])"/>],
  [2012, <xsl:value-of select="count(organization/repo[@private='false' and '2012'>=substring(@created_at,1,4)])"/>],
  [2013, <xsl:value-of select="count(organization/repo[@private='false' and '2013'>=substring(@created_at,1,4)])"/>],
  [2014, <xsl:value-of select="count(organization/repo[@private='false' and '2014'>=substring(@created_at,1,4)])"/>],
  [2015, <xsl:value-of select="count(organization/repo[@private='false' and '2015'>=substring(@created_at,1,4)])"/>],
  [2016, <xsl:value-of select="count(organization/repo[@private='false' and '2016'>=substring(@created_at,1,4)])"/>],
]

privateRepoCount=[
  [2010, <xsl:value-of select="count(organization/repo[@private='true' and '2010'>=substring(@created_at,1,4)])"/>],
  [2011, <xsl:value-of select="count(organization/repo[@private='true' and '2011'>=substring(@created_at,1,4)])"/>],
  [2012, <xsl:value-of select="count(organization/repo[@private='true' and '2012'>=substring(@created_at,1,4)])"/>],
  [2013, <xsl:value-of select="count(organization/repo[@private='true' and '2013'>=substring(@created_at,1,4)])"/>],
  [2014, <xsl:value-of select="count(organization/repo[@private='true' and '2014'>=substring(@created_at,1,4)])"/>],
  [2015, <xsl:value-of select="count(organization/repo[@private='true' and '2015'>=substring(@created_at,1,4)])"/>],
  [2016, <xsl:value-of select="count(organization/repo[@private='true' and '2016'>=substring(@created_at,1,4)])"/>],
]

$.plot($("#repoCountChart"), [ { data: privateRepoCount, label: 'private'}, { data: publicRepoCount, label: 'public' } ],

{
    series: {
        stack: true,
        lines: {
            show: true,
            lineWidth: 2,
        },
        points: { show: true },
        shadowSize: 2
    },
    grid: {
        borderWidth: 0
    },
    legend: {
        position: 'nw'
    },
    colors: ["#0F6BA9", "#2FABE9"]
});
</script>

<script>
issuesOpened=[
  ['2010', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2010'>=@year]/@count)"/>],
  ['2011', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2011'>=@year]/@count)"/>],
  ['2012', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2012'>=@year]/@count)"/>],
  ['2013', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2013'>=@year]/@count)"/>],
  ['2014', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2014'>=@year]/@count)"/>],
  ['2015', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2015'>=@year]/@count)"/>],
  ['2016', <xsl:value-of select="sum(organization/repo/issue-data/issues-opened['2016'>=@year]/@count)"/>],
]

issuesClosed=[
  ['2010', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2010'>=@year]/@count)"/>],
  ['2011', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2011'>=@year]/@count)"/>],
  ['2012', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2012'>=@year]/@count)"/>],
  ['2013', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2013'>=@year]/@count)"/>],
  ['2014', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2014'>=@year]/@count)"/>],
  ['2015', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2015'>=@year]/@count)"/>],
  ['2016', <xsl:value-of select="sum(organization/repo/issue-data/issues-closed['2016'>=@year]/@count)"/>],
]

prsOpened=[
  ['2010', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2010'>=@year]/@count)"/>],
  ['2011', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2011'>=@year]/@count)"/>],
  ['2012', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2012'>=@year]/@count)"/>],
  ['2013', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2013'>=@year]/@count)"/>],
  ['2014', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2014'>=@year]/@count)"/>],
  ['2015', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2015'>=@year]/@count)"/>],
  ['2016', <xsl:value-of select="sum(organization/repo/issue-data/prs-opened['2016'>=@year]/@count)"/>],
]

$.plot($("#issueCountChart"), [ 
{ data: issuesClosed, label: 'closed'}, 
{ data: issuesOpened, label: 'opened'}, 
],

{
    series: {
        stack: true,
        lines: {
            show: true,
            fill: true,
            lineWidth: 2,
        },
        points: { show: true },
        shadowSize: 2
    },
    grid: {
        borderWidth: 0
    },
    legend: {
        position: 'nw'
    },
    colors: ["#0F6BA9", "#2FABE9"]
});

prsClosed=[
  ['2010', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2010'>=@year]/@count)"/>],
  ['2011', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2011'>=@year]/@count)"/>],
  ['2012', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2012'>=@year]/@count)"/>],
  ['2013', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2013'>=@year]/@count)"/>],
  ['2014', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2014'>=@year]/@count)"/>],
  ['2015', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2015'>=@year]/@count)"/>],
  ['2016', <xsl:value-of select="sum(organization/repo/issue-data/prs-closed['2016'>=@year]/@count)"/>],
]

$.plot($("#pullRequestCountChart"), [ 
{ data: prsClosed, label: 'closed' }, 
{ data: prsOpened, label: 'opened'},
],

{
    series: {
        stack: true,
        lines: {
            show: true,
            fill: true,
            lineWidth: 2,
        },
        points: { show: true },
        shadowSize: 2
    },
    grid: {
        borderWidth: 0
    },
    legend: {
        position: 'nw'
    },
    colors: ["#0F8BC9", "#2FABE9"]
});
</script>

<script>
issueResolveTimes=[
  [1, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 hour'])"/>],
  [2, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='3 hours'])"/>],
  [3, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='9 hours'])"/>],
  [4, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 day'])"/>],
  [5, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 week'])"/>],
  [6, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 month'])"/>],
  [7, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 quarter'])"/>],
  [8, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='1 year'])"/>],
  [9, <xsl:value-of select="sum(organization/repo/issue-data/age-count/issue-count[@age='over 1 year'])"/>],
]

$.plot($("#issueTimeToCloseChart"), [ { data: issueResolveTimes} ],

{
    series: {
        stack: true,
        bars: { show: true, barWidth: 0.6 },
    },
    xaxis: {
        ticks: [
          [1, '1 hour'],
          [2, '3 hours'],
          [3, '9 hours'],
          [4, '1 day'],
          [5, '1 week'],
          [6, '1 month'],
          [7, '1 quarter'],
          [8, '1 year'],
          [9, 'over 1 year'] 
        ]
    },
    grid: {
        borderWidth: 0
    },
    colors: ["#0F6BA9"]
});

prResolveTimes=[
  [1, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 hour'])"/>],
  [2, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='3 hours'])"/>],
  [3, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='9 hours'])"/>],
  [4, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 day'])"/>],
  [5, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 week'])"/>],
  [6, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 month'])"/>],
  [7, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 quarter'])"/>],
  [8, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='1 year'])"/>],
  [9, <xsl:value-of select="sum(organization/repo/issue-data/age-count/pr-count[@age='over 1 year'])"/>],
]
$.plot($("#prTimeToCloseChart"), [ { data: prResolveTimes } ],

{
    series: {
        stack: true,
        bars: { show: true, barWidth: 0.6 },
    },
    xaxis: {
        ticks: [
          [1, '1 hour'],
          [2, '3 hours'],
          [3, '9 hours'],
          [4, '1 day'],
          [5, '1 week'],
          [6, '1 month'],
          [7, '1 quarter'],
          [8, '1 year'],
          [9, 'over 1 year'] 
        ]
    },
    grid: {
        borderWidth: 0
    },
    colors: ["#0F6BA9"]
});

$.plot($("#issueCommunityPieChart"), [ { label: "Project", data: <xsl:value-of select="sum(organization/repo/issue-data/community-balance/issue-count[@type='project'])"/>, color: "#0F6BA9" }, { label: "Community", data: <xsl:value-of select="sum(organization/repo/issue-data/community-balance/issue-count[@type='community'])"/>, color: "#2FABE9" } ],
  {
    series: {
      pie: {
        show: true,
        grid: {
            borderWidth: 0
        }
      }
    }

  });
$.plot($("#prCommunityPieChart"), [ { label: "Project", data: <xsl:value-of select="sum(organization/repo/issue-data/community-balance/pr-count[@type='project'])"/>, color: "#0F6BA9" }, { label: "Community", data: <xsl:value-of select="sum(organization/repo/issue-data/community-balance/pr-count[@type='community'])"/>, color: "#2FABE9" } ],
  {
    series: {
      pie: {
        show: true,
        grid: {
            borderWidth: 0
        }
      }
    }

  });
</script>

        <script type="text/javascript">
            $(function(){
                $("#repoTable").tablesorter({
                    sortList: [[0,0]],
                });
                $("#repoMetricsTable").tablesorter({
                    sortList: [[0,0]],
                });
                $("#issueTable").tablesorter({
                    sortList: [[3,1]],
                });
                $("#prTable").tablesorter({
                    sortList: [[3,1]],
                });
                $("#memberTable").tablesorter({
                    sortList: [[0,0]],
                });
            <xsl:for-each select="metadata/reports/report">
                $("#<xsl:value-of select="@key"/>Table").tablesorter({
                    sortList: [[0,0]],
                });
            </xsl:for-each>
            <xsl:for-each select="metadata/db-reports/db-report">
                $("#<xsl:value-of select="@key"/>Table").tablesorter({
                    sortList: [[0,0]],
                });
            </xsl:for-each>
            });
        </script>

       <p>Generated by <a href="https://github.com/amznlabs/oss-dashboard">github.com/amznlabs/oss-dashboard</a>. </p>
       <p><xsl:value-of select="metadata/run-metrics/@usedRateLimit"/> GitHub requests made with <xsl:value-of select="metadata/run-metrics/@endRateLimit"/> remaining. </p>
       <p>Report begun at <xsl:value-of select="substring(metadata/run-metrics/@refreshTime,1,10)"/>.<xsl:value-of select="substring(metadata/run-metrics/@refreshTime,12,5)"/>. </p>
       <p>Report written around <xsl:value-of select="substring(metadata/run-metrics/@generationTime,1,10)"/>.<xsl:value-of select="substring(metadata/run-metrics/@generationTime,12,5)"/>. </p>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="db-reporting-field">
    <xsl:param name="orgname"/>
    <xsl:param name="logo"/>
    <xsl:param name="columntypes"/>
    <xsl:param name="value"/>
    <xsl:param name="index"/>
    <xsl:if test="$columntypes[$index]/@type='text'">
     <td><xsl:value-of select="$value"/></td>
    </xsl:if>
    <xsl:if test="$columntypes[$index]/@type='url'">
     <xsl:variable name="href" select="@id"/>
     <td><a href="{$href}"><xsl:value-of select="$value"/></a></td>
    </xsl:if>
    <xsl:if test="$columntypes[$index]/@type='org/repo'">
     <td><a href="https://github.com/{$value}"><xsl:value-of select="$value"/></a></td>
    </xsl:if>
    <xsl:if test="$columntypes[$index]/@type='org/team'">
     <xsl:variable name="teamname" select="substring-after($value, '/')"/>
     <td><a href="https://github.com/orgs/{$orgname}/teams/{$teamname}"><xsl:value-of select="$value"/></a></td>
    </xsl:if>
    <xsl:if test="$columntypes[$index]/@type='member'">
     <td>
      <xsl:if test="/github-dashdata/organization[@name=$orgname]/member[@login=$value]">
       <!-- TODO: How to allow users to pass in a url and member@internal to their internal directories? -->
       <xsl:if test="$logo">
        <span style="margin-right: 2px;"><sup><img src="{$logo}" width="8" height="8"/></sup></span>
       </xsl:if>
       <xsl:if test="not($logo)">
        <span style="margin-right: 2px;"><sup>&#x2699;</sup></span>
       </xsl:if>
      </xsl:if>
      <a href="https://github.com/{$value}"><xsl:value-of select="$value"/></a>
     </td>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

