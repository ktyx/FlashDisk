/*****************************************************************************
 * TheTVDBGrabber.h
 * Lunettes
 *****************************************************************************
 * Copyright (C) 2010 Pierre d'Herbemont
 * Copyright (C) 2010-2013 VLC authors and VideoLAN
 * $Id$
 *
 * Authors: Pierre d'Herbemont <pdherbemont # videolan.org>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#define TVDB_DEFAULT_LANGUAGE   "en"

#define TVDB_HOSTNAME           "thetvdb.com"
#define TVDB_IMAGES_HOSTNAME    "thetvdb.com"

#define TVDB_API_KEY            "EACB874D8C2A90E2"

/* See http://thetvdb.com/wiki/index.php?title=Programmers_API */
#define TVDB_QUERY_SEARCH       @"http://%s/api/GetSeries.php?seriesname=%@"
#define TVDB_QUERY_SEARCH_NEW   @"http://%s/api/GetSeriesNew.php?seriesname=%@"
#define TVDB_QUERY_SERVER_TIME  @"http://%s/api/Updates.php?type=none"
#define TVDB_QUERY_UPDATES      @"http://%s/api/Updates.php?type=all&time=%@"
#define TVDB_QUERY_INFO         @"http://%s/api/%s/series/%@/%s.xml"
#define TVDB_QUERY_EPISODE_INFO @"http://%s/api/%s/series/%@/all/%s.xml"
#define TVDB_COVERS_URL         @"http://%s/banners/%@"
