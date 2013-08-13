/**
 * Copyright 2013 Albert Vaca <albertvaka@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef BATTERYPACKAGEINTERFACE_H
#define BATTERYPACKAGEINTERFACE_H

#include <knotification.h>

#include "packageinterface.h"
#include <QDBusAbstractAdaptor>

#include "devicebatteryinformation_p.h"

class BatteryPackageInterface
    : public PackageInterface
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.kde.kdeconnect.battery")

public:
    BatteryPackageInterface(QObject* parent);
    virtual bool receivePackage(const Device&, const NetworkPackage& np);

private:
    QHash<QString,DeviceBatteryInformation*> mDevices;

public Q_SLOTS:
    Q_SCRIPTABLE QStringList getBatteryReportingDevices();

Q_SIGNALS:
    Q_SCRIPTABLE void batteryDeviceAdded(const QString& id);
    Q_SCRIPTABLE void batteryDeviceLost(const QString& id);

public slots:
    void deviceReachableStatusChange();
};

#endif